"""Kho hội thoại SQLite cục bộ. Mọi truy vấn đều giới hạn theo trình duyệt."""
import json
import secrets
import sqlite3
from contextlib import contextmanager
from pathlib import Path


class Conversations:
    def __init__(self, path):
        self.path = Path(path)
        self.path.parent.mkdir(exist_ok=True, parents=True)
        with self.connection() as db:
            db.executescript("""
                CREATE TABLE IF NOT EXISTS settings (name TEXT PRIMARY KEY, value TEXT NOT NULL);
                CREATE TABLE IF NOT EXISTS threads (
                    id TEXT PRIMARY KEY, owner TEXT NOT NULL, title TEXT NOT NULL,
                    revision INTEGER NOT NULL DEFAULT 0, profile TEXT, result TEXT,
                    updated TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')));
                CREATE INDEX IF NOT EXISTS owner_updated ON threads(owner, updated DESC);
                CREATE TABLE IF NOT EXISTS events (
                    thread TEXT NOT NULL REFERENCES threads(id) ON DELETE CASCADE,
                    seq INTEGER NOT NULL, kind TEXT NOT NULL, payload TEXT NOT NULL,
                    PRIMARY KEY(thread, seq));
            """)
            db.execute("INSERT OR IGNORE INTO settings VALUES ('session_key', ?)", (secrets.token_hex(32),))
            self.key = db.execute("SELECT value FROM settings WHERE name='session_key'").fetchone()[0]

    @contextmanager
    def connection(self):
        db = sqlite3.connect(self.path, timeout=8)
        db.row_factory = sqlite3.Row
        db.execute("PRAGMA foreign_keys=ON")
        try:
            with db:
                yield db
        finally:
            db.close()

    def list(self, owner):
        with self.connection() as db:
            return [dict(row) for row in db.execute(
                "SELECT id,title,updated FROM threads WHERE owner=? ORDER BY updated DESC, rowid DESC", (owner,))]

    def create(self, owner):
        ident = secrets.token_urlsafe(18)
        with self.connection() as db:
            db.execute("INSERT INTO threads(id,owner,title) VALUES(?,?,?)", (ident,owner,"Cuộc trò chuyện mới"))
        return ident

    def read(self, owner, ident, include_events=True, page_size=None, before=None):
        with self.connection() as db:
            db.execute("BEGIN")
            row = db.execute("SELECT id,title,revision,profile,result FROM threads WHERE owner=? AND id=?", (owner,ident)).fetchone()
            if row is None:
                return None
            thread = dict(row)
            for key in ("profile","result"):
                thread[key] = json.loads(thread[key]) if thread[key] else None
            if page_size:
                rows = db.execute("""SELECT seq,kind,payload FROM events
                    WHERE thread=? AND seq<? ORDER BY seq DESC LIMIT ?""",
                    (ident, before if before is not None else thread["revision"]+1, page_size+1)).fetchall()
                page = rows[:page_size]
                thread["events"] = [dict(seq=e["seq"],kind=e["kind"],**json.loads(e["payload"])) for e in reversed(page)]
                thread["before"] = page[-1]["seq"] if len(rows)>page_size else None
                screen = db.execute("""SELECT payload FROM events WHERE thread=? AND kind='screen'
                    ORDER BY seq DESC LIMIT 1""", (ident,)).fetchone()
                thread["screen_accuracy"] = json.loads(screen[0])["accuracy"] if screen else None
                thread["has_manual"] = bool(db.execute("""SELECT 1 FROM events WHERE thread=? AND kind='chat'
                    AND NOT coalesce(json_extract(payload,'$.automatic'),0) LIMIT 1""", (ident,)).fetchone())
            elif include_events:
                thread["events"] = [dict(kind=e["kind"], **json.loads(e["payload"])) for e in db.execute(
                    "SELECT kind,payload FROM events WHERE thread=? ORDER BY seq", (ident,))]
        return thread

    def chat_turns(self, owner, thread):
        with self.connection() as db:
            rows = db.execute("""SELECT e.payload FROM events e JOIN threads t ON e.thread=t.id
                WHERE t.owner=? AND t.id=? AND e.kind='chat' AND e.seq<=? ORDER BY e.seq""",
                (owner, thread["id"], thread["revision"]))
            for row in rows:
                yield json.loads(row["payload"])

    def append(self, owner, thread, kind, payload, title):
        with self.connection() as db:
            updated = db.execute("""UPDATE threads SET revision=revision+1,
                updated=strftime('%Y-%m-%dT%H:%M:%fZ','now'), title=?
                WHERE owner=? AND id=? AND revision=?""",
                (title,owner,thread["id"],thread["revision"]))
            if not updated.rowcount:
                return False
            if kind == "screen":
                db.execute("UPDATE threads SET profile=?, result=? WHERE id=?",
                           (json.dumps(payload["profile"]),json.dumps(payload["result"]),thread["id"]))
            db.execute("INSERT INTO events VALUES(?,?,?,?)", (thread["id"],thread["revision"]+1,kind,json.dumps(payload,ensure_ascii=False)))
        return True

    def delete(self, owner, ident):
        with self.connection() as db:
            return bool(db.execute("DELETE FROM threads WHERE owner=? AND id=?", (owner,ident)).rowcount)

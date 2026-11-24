import argparse
import json
import os
from pathlib import Path
from time import monotonic
import requests

ROOT = Path(__file__).resolve().parents[1]
HERE = Path(__file__).resolve().parent

def read_sources():
    result = {}
    for prefix, file in [("W","links.txt"),("P","pdf/sources.txt")]:
        lines = (ROOT/"sources"/file).read_text(encoding="utf-8-sig").splitlines()
        for i in range(0,len(lines),2):
            number,owner,title,*_ = [x.strip() for x in lines[i].split("|")]
            result[prefix+number] = dict(id=prefix+number, owner=owner,title=title,url=lines[i+1],format="PDF" if prefix=="P" else "HTML")
    return result

SOURCES=read_sources()
FACTS=[dict(id=f"F{i:02}",source=s,topic=t,concept=c,text=v,section=loc) for i,(s,t,c,v,loc) in enumerate(json.loads((HERE/"facts.json").read_text(encoding="utf8")),1)]
for path in sorted((HERE/"passages").glob("*.json")):
    FACTS.extend(json.loads(path.read_text(encoding="utf8")))

QUERY="""MATCH (t:DiabetesTopic)<-[:ABOUT]-(f:DiabetesFact)-[:CITES]->(s:DiabetesSource)
MATCH (f)-[:DESCRIBES]->(c:DiabetesConcept)
WHERE $topic IS NULL OR t.id=$topic
RETURN f.id,s.id,f.text,f.section,c.name,t.id ORDER BY f.id"""

RECONNECT_DELAY = 15
_retry_after = 0.0

def tx(statement, params=None, timeout=4):
    base=os.getenv("NEO4J_HTTP","http://127.0.0.1:17474").rstrip("/")
    password=os.getenv("NEO4J_PASSWORD")
    secret=ROOT/"local"/"neo4j-password.txt"
    if password is None and secret.exists():
        password=secret.read_text().strip()
    auth=(os.getenv("NEO4J_USER","neo4j"),password) if password else None
    r=requests.post(base+"/db/neo4j/tx/commit",json={"statements":[{"statement":statement,"parameters":params or {}}]},auth=auth,timeout=timeout)
    r.raise_for_status()
    data=r.json()
    if data["errors"]:
        raise ValueError(data["errors"][0]["message"])
    return [entry["row"] for entry in data["results"][0]["data"]]

def _read_rows(statement, params=None):
    global _retry_after
    try:
        rows = tx(statement, params)
    except (requests.ConnectionError, requests.Timeout):
        _retry_after = monotonic() + RECONNECT_DELAY
        raise
    _retry_after = 0.0
    return rows

def retrieve(topic=None):
    local=[f for f in FACTS if topic is None or f["topic"]==topic]
    if monotonic() < _retry_after:
        return local,"Bản sao tri thức cục bộ"
    try:
        rows=_read_rows(QUERY,{"topic":topic})
        graph=[dict(id=i,source=s,text=v,section=sec,concept=c,topic=t) for i,s,v,sec,c,t in rows]
        if graph and graph==sorted(local,key=lambda f:f["id"]):
            return graph,"Neo4j"
    except (requests.RequestException, ValueError):
        pass
    return local,"Bản sao tri thức cục bộ"

def statements():
    for label in ("DiabetesSource","DiabetesFact","DiabetesTopic","DiabetesConcept"):
        key="name" if label=="DiabetesConcept" else "id"
        yield f"CREATE CONSTRAINT IF NOT EXISTS FOR (n:{label}) REQUIRE n.{key} IS UNIQUE"
    def literal(v):
        return "'" + v.replace(chr(92),chr(92)*2).replace("'",chr(92)+"'") + "'"
    for s in SOURCES.values():
        yield "MERGE (s:DiabetesSource {id:"+literal(s["id"])+"}) SET "+", ".join("s."+k+"="+literal(s[k]) for k in ("title","owner","url","format"))
    for f in FACTS:
        yield ("MATCH (s:DiabetesSource {id:"+literal(f["source"])+"}) "
               "MERGE (t:DiabetesTopic {id:"+literal(f["topic"])+"}) "
               "MERGE (c:DiabetesConcept {name:"+literal(f["concept"])+"}) "
               "MERGE (f:DiabetesFact {id:"+literal(f["id"])+"}) "
               "SET f.text="+literal(f["text"])+", f.section="+literal(f["section"])+" "
               "MERGE (f)-[:ABOUT]->(t) MERGE (f)-[:DESCRIBES]->(c) MERGE (f)-[:CITES]->(s)")

def live_count():
    return _read_rows("MATCH (f:DiabetesFact) RETURN count(f)")[0][0]

if __name__=="__main__":
    parser=argparse.ArgumentParser()
    parser.add_argument("--load",action="store_true")
    args=parser.parse_args()
    commands=list(statements())
    (HERE/"kb_diabet.cypher").write_text(";\n\n".join(commands)+";\n",encoding="utf8")
    if args.load:
        for statement in commands:
            tx(statement,timeout=20)
        print("Neo4j:",live_count(),"facts")


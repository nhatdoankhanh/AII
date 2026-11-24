"""Ứng dụng demo cục bộ. Chạy python main.py từ thư mục dự án."""
import json
import logging
import os
import secrets
from datetime import timedelta
from threading import Lock, Thread
from flask import Flask, render_template, request, session, jsonify, send_from_directory
import requests
from agents.settings import CONFIG, TOPICS
from deep_learning.schema import ART, ROOT, FIELDS, SPECIAL, CLASSES, TYPES_VI
from knowledge_base.graph import SOURCES, FACTS, live_count, retrieve
from conversations import Conversations

app=Flask(__name__,template_folder="interface",static_folder="interface/static")
threads = Conversations(os.getenv("DIABETES_CHAT_DB", ROOT/"local"/"conversations.sqlite3"))
app.secret_key=threads.key
app.config.update(MAX_CONTENT_LENGTH=65536,SESSION_COOKIE_SAMESITE="Strict",PERMANENT_SESSION_LIFETIME=timedelta(days=365))
QUESTION_LIMIT = 4000
_predictor = None
_predictor_lock = Lock()
metrics=json.loads((ART/"metrics.json").read_text(encoding="utf8"))
_status_lock=Lock()
_status_cache={"neo4j":None,"checked":0.0}

def get_predictor():
    global _predictor
    with _predictor_lock:
        if _predictor is None:
            import torch
            from deep_learning.model import Predictor

            torch.set_num_threads(2)
            _predictor = Predictor()
        return _predictor

@app.get("/")
def home():
    browser_id()
    return render_template("index.html",fields=FIELDS,special=SPECIAL,metrics=metrics,topics=TOPICS,sources=SOURCES,types=[TYPES_VI[x] for x in CLASSES],model_label=CONFIG["label"],question_limit=QUESTION_LIMIT)

def browser_id():
    if "owner" not in session:
        session["owner"]=secrets.token_urlsafe(24)
        session.permanent=True
    return session["owner"]

@app.get("/api/threads")
def list_threads():
    return jsonify(threads=threads.list(browser_id()))

@app.route("/api/threads/<ident>",methods=["GET","DELETE"])
def get_thread(ident):
    owner=browser_id()
    if request.method=="DELETE":
        if threads.delete(owner,ident):
            return jsonify(deleted=True)
    else:
        page_size = request.args.get("limit", type=int)
        if page_size is not None and not 1<=page_size<=100:
            return jsonify(error="Số lượt cần tải phải từ 1 đến 100."),400
        before = request.args.get("before", type=int)
        if before is not None and not 1<=before<=2**63-1:
            return jsonify(error="Vị trí trong lịch sử không hợp lệ."),400
        thread=threads.read(owner,ident,page_size=page_size,before=before)
        if thread:
            return jsonify(thread)
    return jsonify(error="Không tìm thấy cuộc trò chuyện."),404

def conflict():
    return jsonify(error="Hội thoại đã thay đổi ở một lượt khác. Hãy mở lại hội thoại rồi thử lại."),409

@app.errorhandler(413)
def request_too_large(error):
    return jsonify(error="Dữ liệu gửi quá lớn. Hãy rút ngắn nội dung rồi gửi lại."),413

@app.get("/charts/<name>")
def chart(name):
    return send_from_directory(ART/"charts",name)

@app.post("/api/predict")
def predict():
    values=request.get_json(silent=True)
    if not isinstance(values,dict):
        return jsonify(error="Dữ liệu nhập không hợp lệ."),400
    try:
        result=get_predictor().predict(values)
    except ValueError as exc:
        return jsonify(error=str(exc)),400
    except (TypeError,OverflowError):
        return jsonify(error="Hãy nhập đúng kiểu dữ liệu."),400
    owner=browser_id()
    ident=values.get("thread_id") or threads.create(owner)
    thread=threads.read(owner,ident,include_events=False)
    if not thread:
        return jsonify(error="Không tìm thấy cuộc trò chuyện."),404
    if values.get("revision",thread["revision"])!=thread["revision"]:
        return conflict()
    profile={k:v for k,v in values.items() if k in {*FIELDS,"pregnant","mode"} and v not in (None,"")}
    payload=dict(profile=profile,result=result,accuracy=metrics["test"][result["mode"]]["accuracy"])
    if not threads.append(owner,thread,"screen",payload,thread["title"]):
        return conflict()
    session["active"]=ident
    return jsonify(thread_id=ident,revision=thread["revision"]+1,**payload)

@app.post("/api/chat")
def chat():
    data=request.get_json(silent=True)
    question=data.get("question") if isinstance(data,dict) else None
    if not isinstance(question,str) or not 1<=len(question.strip())<=QUESTION_LIMIT:
        return jsonify(error=f"Câu hỏi cần từ 1 đến {QUESTION_LIMIT} ký tự."),400
    owner=browser_id()
    thread=threads.read(owner,data.get("thread_id",session.get("active")),include_events=False)
    if not thread or not thread["result"]:
        return jsonify(error="Vui lòng thực hiện sàng lọc trước khi hỏi."),409
    if data.get("revision",thread["revision"])!=thread["revision"]:
        return conflict()
    model=data.get("model",CONFIG["model"])
    if model != CONFIG["model"]:
        return jsonify(error="Mô hình tư vấn không hợp lệ."),400
    from agents.advisor import ChatHistory, answer
    history = ChatHistory(question, threads.chat_turns(owner,thread))
    web_search=data.get("web_search",True)
    if not isinstance(web_search,bool):
        return jsonify(error="Tùy chọn tìm kiếm trực tuyến không hợp lệ."),400
    response=answer(question.strip(),thread["result"],history=history,profile=thread["profile"],model=model,web_search=web_search)
    response["requested_model"]=model
    title=thread["title"]
    if not data.get("automatic") and not history.last_questions:
        title=question.strip()[:76]
    payload=dict(question=question.strip(),response=response,automatic=data.get("automatic") is True)
    if not threads.append(owner,thread,"chat",payload,title):
        return conflict()
    return jsonify(**response,revision=thread["revision"]+1)

@app.get("/api/status")
def status():
    now=__import__("time").monotonic()
    with _status_lock:
        neo4j=_status_cache["neo4j"]
        refresh=now-_status_cache["checked"]>=20
        if refresh:
            _status_cache["checked"]=now
    if refresh:
        def update_graph_status():
            try:
                count=live_count()
            except (requests.RequestException,ValueError):
                count=None
            with _status_lock:
                _status_cache["neo4j"]=count
        Thread(target=update_graph_status,daemon=True).start()
    try:
        models=requests.get(CONFIG["base_url"]+"/api/tags",timeout=(0.3,0.7)).json()["models"]
        installed={m["name"] for m in models}
    except (requests.RequestException,ValueError,KeyError):
        installed=set()
    pdf_names=["bo-y-te-5481-2020.pdf","niddk-4-steps.pdf"]
    return jsonify(neo4j=neo4j,expected=len(FACTS),ollama=CONFIG["model"] in installed,
                   installed_models=[CONFIG["model"]] if CONFIG["model"] in installed else [],
                   pdfs=sum((ROOT/"sources"/"pdf"/f).is_file() for f in pdf_names))

@app.get("/api/evidence")
@app.get("/api/evidence/<topic>")
def evidence(topic=None):
    topic = topic or request.args.get("topic") or None
    query = request.args.get("q", "").strip()
    if topic is not None and topic not in TOPICS:
        return jsonify(error="Chủ đề không tồn tại."),404
    if len(query) > 600:
        return jsonify(error="Nội dung tra cứu tối đa 600 ký tự."),400
    facts, backend = retrieve(topic)
    if query:
        from agents.advisor import INDEX, POLICY
        facts = INDEX.rank(query, facts, POLICY)
    return jsonify(backend=backend, items=[
        dict(text=f["text"], concept=f["concept"], section=f["section"],
             topic=TOPICS[f["topic"]], source=SOURCES[f["source"]]) for f in facts
    ])

if __name__=="__main__":
    logging.basicConfig(level=logging.INFO)
    app.run(host="127.0.0.1",port=int(os.getenv("DIABETES_PORT","7860")),threaded=True)


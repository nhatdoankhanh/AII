const $=s=>document.querySelector(s);
const all=s=>[...document.querySelectorAll(s)];
const form=$("#form");
const pct=n=>(100*n).toLocaleString("vi-VN",{minimumFractionDigits:1,maximumFractionDigits:1})+"%";
let current=null, mode="lab", selection=0, dirty=false, pendingScreen=false, view="screen";
const pending=new Map();
let webSearch=true;
const chatPageSize=30;
function readChatPage(id,before){
  return api("/api/threads/"+id+"?limit="+chatPageSize+(before?"&before="+before:""));
}
function element(parent,tag,text,cls) {
  const node=document.createElement(tag);
  if(cls)node.className=cls;
  node.textContent=text;parent.append(node);return node;
}
function link(parent,source,label,section="") {
  const a=element(parent,"a",label||source.owner+" · "+source.title);
  const page=source.format==="PDF" && section.match(/PDF tr\. (\d+)/);
  a.href=source.url+(page?"#page="+page[1]:"");a.target="_blank";a.rel="noreferrer";
  a.title=source.owner+" · "+source.title+" · "+section;
}
async function api(path,method="GET",data) {
  const opts={method};
  if(data){opts.headers={"Content-Type":"application/json"};opts.body=JSON.stringify(data);}
  const r=await fetch(path,opts);
  const body=await r.json();if(!r.ok)throw new Error(body.error||"Yêu cầu chưa hoàn tất.");
  return body;
}
const samples={
 low:{mode:"lab",age:30,bmi:23,female:1,bp:0,heart:0,a1c:5,glucose:95},
 high:{mode:"lab",age:49,bmi:38,glucose:150,waist:38,a1c:6.8,bp:1,heart:0,female:0,auto:0,gene:0,steroid:0,cf:0,family:1,early:0,pregnant:"no"},
 survey:{mode:"survey",age:67,bmi:36,female:0,bp:1,heart:0,active:0,chol:1}};

function useMode(value){
  mode=value==="survey"?"survey":"lab";
  for(const b of all("[data-mode]")){b.classList.toggle("on",b.dataset.mode===mode);b.setAttribute("aria-pressed",b.dataset.mode===mode);}
  for(const l of all("label.lab,label.survey")){l.hidden=!l.classList.contains(mode);l.querySelector("input,select").disabled=l.hidden;}
}
function fill(profile={}){
  form.reset();useMode(profile.mode);
  for(const input of form.querySelectorAll("[name]"))if(profile[input.name]!=null)input.value=profile[input.name];
  $("#extra").open=false;
}
function closeDrawers(){
  document.body.classList.remove("show-profile","show-history");$("#scrim").hidden=true;
}
function showProfile(){
  closeDrawers();document.body.classList.remove("profile-hidden");
  if(matchMedia("(max-width:1050px)").matches){document.body.classList.add("show-profile");$("#scrim").hidden=false;}
  $("#profile").scrollTo(0,0);
}
$("#toggle-profile").onclick=()=>{
  if(view!=="screen")showView("screen");
  if(matchMedia("(max-width:1050px)").matches)showProfile();
  else document.body.classList.toggle("profile-hidden");
};
$("#toggle-history").onclick=()=>{
  if(matchMedia("(max-width:750px)").matches){closeDrawers();document.body.classList.add("show-history");$("#scrim").hidden=false;}
  else document.body.classList.toggle("side-hidden");
};
$("#scrim").onclick=closeDrawers;
for(const b of all("[data-close]"))b.onclick=closeDrawers;
document.addEventListener("keydown",e=>{if(e.key==="Escape")closeDrawers();});
function showView(name){
  view=name;closeDrawers();
  $("#screen").hidden=name!=="screen";$("#tools-view").hidden=name==="screen";
  $("#research").hidden=name!=="research";$("#knowledge").hidden=name!=="knowledge";
  $("#page-title").textContent=name==="screen"?"Diabetes Research AI":name==="research"?"Thực nghiệm":"Kho tri thức";
  for(const b of all(".tool"))b.classList.toggle("active",b.dataset.view===name);
  if(name==="knowledge"){status();evidence();}
}
for(const b of all(".tool"))b.onclick=()=>showView(b.dataset.view);
$("#back").onclick=()=>showView("screen");
function renderResult(){
  const r=current?.result;$("#result").hidden=!r||dirty;
  if(!r||dirty)return;
  $("#verdict").textContent=r.positive?"Có dấu hiệu nguy cơ":"Dưới ngưỡng nguy cơ";
  const box=$("#result-text");box.replaceChildren();
  element(box,"strong","Điểm sàng lọc "+pct(r.score));
  element(box,"small","Ngưỡng "+pct(r.threshold)+" · Accuracy test "+pct(current.screen_accuracy));
  if(r.positive)element(box,"p",r.subtype?"Thể bệnh gợi ý: "+r.subtype:r.reason);
}
function lockControls(){
  const waiting=pending.has(current?.id);
  form.inert=pendingScreen;
  const enabled=!!current?.result&&!dirty&&!waiting&&!pendingScreen;
  const question=$("#question"),counter=$("#question-count");
  const value=question.value.trim(),limit=Number(question.dataset.limit);
  let length=0;
  for(const char of value)length++;
  counter.hidden=!length;
  counter.textContent=length>limit?`Vượt giới hạn ${length-limit} ký tự. Hãy rút ngắn hoặc gửi thành nhiều lượt.`:`${length} / ${limit} ký tự`;
  question.disabled=!enabled;$("#send").disabled=!enabled||!length||length>limit;
  $("#question").placeholder=waiting?"Trợ lý đang trả lời…":!current?.result||dirty?"Hoàn tất sàng lọc để nhắn tin…":"Nhắn tin về bệnh tiểu đường…";
  $(".chips").hidden=!enabled||current.has_manual;
  form.querySelector("[type=submit]").disabled=pendingScreen||waiting;
}
function scrollEnd(){const feed=$("#feed");feed.scrollTop=feed.scrollHeight;}
function drawChat(){
  const panel=$("#conversation");panel.replaceChildren();
  if(!current?.events.length){
    const w=element(panel,"div","","welcome");element(w,"span","D","welcome-mark");
    element(w,"h2","Bắt đầu cuộc trò chuyện");
    element(w,"p","Điền hồ sơ sàng lọc để nhận kết quả và hỏi trợ lý về tiểu đường.");
    const b=element(w,"button","Mở hồ sơ sàng lọc");b.onclick=()=>{showProfile();$("#sample").focus();};
  } else {
    if(current.before){
      const earlier=element(panel,"button","Xem tin nhắn cũ hơn","screen-event");
      earlier.onclick=async()=>{
        const thread=current, before=thread.before;
        earlier.disabled=true;
        try{
          const page=await readChatPage(thread.id,before);
          if(current!==thread || current.before!==before)return;
          const feed=$("#feed"),height=feed.scrollHeight,top=feed.scrollTop;
          thread.events=page.events.concat(thread.events);thread.before=page.before;
          drawChat();feed.scrollTop=top+feed.scrollHeight-height;
        }catch(err){report(err);earlier.disabled=false;}
      };
    }
    for(const e of current.events){
      if(e.kind==="screen"){
        element(panel,"div","Đã sàng lọc · "+pct(e.result.score)+" · "+(e.result.positive?"Có dấu hiệu nguy cơ":"Dưới ngưỡng nguy cơ"),"screen-event");
      }else{
        if(!e.automatic)userMessage(panel,e.question);
        assistantMessage(panel,e.response);
      }
    }
    if(pending.has(current.id)){
      const p=pending.get(current.id);if(!p.automatic)userMessage(panel,p.question);
      element(panel,"div","Đang truy xuất tài liệu và hỏi "+p.modelLabel+"…","screen-event");
    }
  }
  lockControls();scrollEnd();
}
function userMessage(parent,text){
  const row=element(parent,"div","","speaker user");element(row,"div",text,"bubble");element(row,"span","B","user-mark");
}
function assistantMessage(parent,response){
  const row=element(parent,"div","","speaker");element(row,"span","D","assistant-mark");
  const words=element(row,"div","","words");
  if(response.intro)element(words,"p",response.intro);
  const refs=new Map();
  for(const item of response.items){
    const paragraph=element(words,"p",item.text);
    for(const ref of item.references||[item]){
      const key=ref.id||ref.source.id+" "+ref.section;
      if(!refs.has(key))refs.set(key,{ref,number:refs.size+1});
      paragraph.append(" ");
      link(paragraph,ref.source,"["+refs.get(key).number+"]",ref.section);
    }
  }
  const details=element(words,"details","","sources");
  element(details,"summary",response.items.length?"Nguồn và cách trả lời":"Chi tiết");
  for(const {ref,number} of refs.values()){
    link(details,ref.source,"["+number+"] "+ref.source.owner+" · "+ref.source.title,ref.section);
    element(details,"small",ref.section);
    if(ref.excerpt)element(details,"small",ref.excerpt);
  }
  element(details,"small",response.trace.join(" → "));
}
let listRequest=0;
async function listHistory(){
  const seq=++listRequest;const {threads}=await api("/api/threads");
  if(seq!==listRequest)return threads;
  const box=$("#history");box.replaceChildren();
  if(!threads.length)element(box,"p","Chưa có cuộc trò chuyện.","history-empty");
  for(const t of threads){
    const row=element(box,"div","","entry"+(t.id===current?.id?" active":""));
    const btn=element(row,"button",t.title,"entry-name");btn.title=t.title;btn.onclick=()=>openThread(t.id);
    const del=element(row,"button","×","remove");del.title="Xóa cuộc trò chuyện";del.setAttribute("aria-label","Xóa "+t.title);
    del.onclick=async()=>{
      if(!confirm("Xóa cuộc trò chuyện này và toàn bộ tin nhắn đã lưu?"))return;
      try{await api("/api/threads/"+t.id,"DELETE");if(current?.id===t.id)newThread();await listHistory();}catch(e){report(e);}
    };
  }
  return threads;
}
function report(error){$("#chat-error").textContent=error.message;}
function resetInput(){
  dirty=false;$("#question").value="";$("#question").style.height="auto";$("#form-error").textContent="";$("#chat-error").textContent="";
}
async function openThread(id){
  const n=++selection;
  try{
    const data=await readChatPage(id);if(n!==selection)return;
    current=data;resetInput();fill(current.profile||{});showView("screen");renderResult();drawChat();
    history.replaceState(null,"","#chat/"+id);await listHistory();
  }catch(e){if(n===selection)report(e);}
}
function newThread(){
  ++selection;current=null;resetInput();fill();showView("screen");history.replaceState(null,"",location.pathname);
  renderResult();drawChat();listHistory().catch(report);
}
$("#new-thread").onclick=newThread;
function edited(){
  dirty=true;$("#chat-error").textContent=current?.result?"Tính lại ước tính để dùng hồ sơ vừa sửa.":"";
  renderResult();lockControls();
}
for(const b of all("[data-mode]"))b.onclick=()=>{useMode(b.dataset.mode);edited();};
form.addEventListener("input",edited);
$("#sample").onchange=e=>{
  const k=e.target.value;if(!samples[k])return;
  fill(samples[k]);$("#sample").value=k;$("#extra").open=k==="high";edited();
};
form.onsubmit=async e=>{
  e.preventDefault();if(pendingScreen||pending.has(current?.id))return;
  const at=selection;const values={...Object.fromEntries(new FormData(form)),mode};
  if(current)Object.assign(values,{thread_id:current.id,revision:current.revision});
  pendingScreen=true;lockControls();$("#form-error").textContent="";
  try{
    const d=await api("/api/predict","POST",values);
    const saved=await readChatPage(d.thread_id);
    if(at!==selection){await listHistory();return;}
    current=saved;dirty=false;$("#chat-error").textContent="";history.replaceState(null,"","#chat/"+current.id);
    renderResult();drawChat();closeDrawers();
    if(!matchMedia("(max-width:1050px)").matches)$("#profile").scrollTop=$("#profile").scrollHeight;
    await listHistory();
    if(at===selection)await ask(d.result.positive?"Tôi cần xét nghiệm gì để xác nhận kết quả?":"Tôi nên theo dõi sức khỏe tại nhà thế nào?",true);
  }catch(err){if(at===selection)$("#form-error").textContent=err.message;}
  finally{pendingScreen=false;lockControls();}
};
async function ask(text,automatic=false){
  const question=text.trim();if(!current||!question||dirty||pending.has(current.id))return;
  const id=current.id,revision=current.revision;
  let refresh=false;
  pending.set(id,{question,automatic,modelLabel:$("#chat-model").textContent});$("#question").value="";$("#question").style.height="auto";$("#chat-error").textContent="";drawChat();
  try{
    const {revision:next,...response}=await api("/api/chat","POST",{thread_id:id,revision,question,automatic,web_search:webSearch});
    if(current?.id===id && current.revision===revision){
      current.events.push({seq:next,kind:"chat",question,automatic,response});current.revision=next;
      if(!automatic)current.has_manual=true;
      if(current.events.length>chatPageSize){
        current.events=current.events.slice(-chatPageSize);current.before=current.events[0].seq;
      }
    }else refresh=true;
  }catch(err){
    refresh=true;
    if(current?.id===id){report(err);if(!automatic)$("#question").value=question;}
  }finally{
    pending.delete(id);
    try{
      if(refresh && current?.id===id){const data=await readChatPage(id);if(current?.id===id)current=data;}
      await listHistory();
    }catch(err){report(err);}
    finally{if(current?.id===id)drawChat();}
  }
}
$("#web-search-toggle").onclick=event=>{
  webSearch=!webSearch;
  const button=event.currentTarget;
  button.textContent="Tìm kiếm trực tuyến · "+(webSearch?"Bật":"Tắt");
  button.setAttribute("aria-pressed",String(webSearch));
};
$("#ask").onsubmit=e=>{e.preventDefault();if(!$("#send").disabled)ask($("#question").value);};
$("#question").oninput=e=>{e.target.style.height="auto";e.target.style.height=Math.min(e.target.scrollHeight,96)+"px";lockControls();};
$("#question").onkeydown=e=>{if(e.key==="Enter"&&!e.shiftKey&&!e.isComposing){e.preventDefault();if(!$("#send").disabled)ask(e.target.value);}};
for(const b of all(".chips button"))b.onclick=()=>ask(b.textContent);
async function status() {
  try {
    const d=await (await fetch("/api/status")).json();
    const label=$("#chat-model").textContent;
    $("#model-status").classList.toggle("ready",d.ollama);
    $("#model-status span").textContent=label+" · "+(d.ollama?"Sẵn sàng":"Chưa có trên Ollama");
    $("#status").textContent="Ollama: "+(d.ollama?label:"chưa có mô hình")+" · "+(d.neo4j===null?"Neo4j chưa kết nối; truy xuất dùng bản sao cục bộ":"Neo4j: "+d.neo4j+"/"+d.expected+" mục tri thức")+" · PDF gốc trên máy: "+d.pdfs+"/2";
  }catch{$("#model-status span").textContent="Chưa xác định trạng thái Ollama";$("#status").textContent="Chưa đọc được trạng thái.";}
}
let evidenceRequest=0;
async function evidence() {
  const seq=++evidenceRequest;
  const q=$("#evidence-query").value.trim(),topic=$("#topic").value;
  const panel=$("#evidence"),statusLine=$("#evidence-status");
  panel.replaceChildren();
  statusLine.textContent="Đang tìm đoạn nguồn…";
  try {
    const data=await api("/api/evidence?"+new URLSearchParams({q,topic}));
    if(seq!==evidenceRequest)return;
    statusLine.textContent=data.items.length
      ? data.items.length+" đoạn nguồn"+(q?" cho “"+q+"”":"")+" · "+data.backend
      : "Chưa tìm thấy đoạn nguồn phù hợp. Hãy thử từ khóa khác hoặc đổi chủ đề.";
    for(const item of data.items){
      const article=element(panel,"article","");
      element(article,"small",item.topic);
      element(article,"strong",item.concept);
      element(article,"p",item.text);
      link(article,item.source,null,item.section);
      element(article,"small",item.section);
    }
  }catch{
    if(seq===evidenceRequest)statusLine.textContent="Chưa truy xuất được kho tri thức. Hãy thử lại.";
  }
}

$("#evidence-search").onsubmit=e=>{e.preventDefault();evidence();};
$("#refresh").onclick=async()=>{await status();await evidence();};$("#topic").onchange=evidence;
async function init(){
  fill();drawChat();status();
  const threads=await listHistory();
  const selected=location.hash.match(/^#chat\/([\w-]+)$/)?.[1];
  const id=threads.find(t=>t.id===selected)?.id||threads[0]?.id;
  if(id)await openThread(id);
}
init().catch(report);

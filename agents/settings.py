import json
from knowledge_base.graph import ROOT

CONFIG=json.loads((ROOT/"config/llm.json").read_text(encoding="utf8"))
TOPICS={"food":"Dinh dưỡng","medicine":"Thuốc","symptom":"Triệu chứng","complication":"Biến chứng","test":"Xét nghiệm","care":"Theo dõi","low":"Hạ đường huyết","urgent":"Cấp cứu","overview":"Tổng quan","pregnancy":"Thai kỳ"}

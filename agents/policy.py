"""Contextual bandit: trạng thái = từ trong câu hỏi, hành động = chủ đề truy xuất."""
import json
import re
import unicodedata
from pathlib import Path
import numpy as np

HERE=Path(__file__).resolve().parent
EXAMPLES={
    "food":["nên ăn gì","hạn chế thực phẩm nào","bữa ăn cơm rau cá","ăn kiêng thế nào","uống nước ngọt được không","trái cây nước ép","dinh dưỡng khẩu phần","bánh kẹo đường và tinh bột","thực đơn ăn sáng","chọn món khi ăn ngoài nhà hàng","đi ăn quán gọi món nào"],
    "medicine":["nên uống thuốc gì","tôi cần tiêm insulin không","liều dùng thuốc điều trị","có được ngừng thuốc","metformin bao nhiêu viên","tác dụng thuốc uống","đổi liều thuốc","kê đơn cho tôi"],
    "symptom":["triệu chứng của bệnh","dấu hiệu nhận biết","hay khát và tiểu nhiều","vì sao nhìn mờ mệt mỏi","biểu hiện của tiểu đường","vết thương lâu lành"],
    "complication":["biến chứng như thế nào","ảnh hưởng đến thận","tổn thương mắt và thần kinh","biến chứng bàn chân","có ảnh hưởng tim mạch","suy thận do bệnh"],
    "test":["cần xét nghiệm gì","HbA1c là gì","kiểm tra glucose máu","xác định típ bệnh thế nào","kết quả sàng lọc có nghĩa gì","tôi có cần xét nghiệm thêm","xét nghiệm chẩn đoán"],
    "pregnancy":["tiểu đường thai kỳ","đang mang thai","đường huyết lúc có thai","mẹ bầu tiểu đường","tôi đang có bầu"],
    "low":["hạ đường huyết có dấu hiệu gì","đường huyết thấp","run tay vã mồ hôi","bị tụt đường máu"],
    "urgent":["ngất không tỉnh","bất tỉnh co giật","mất ý thức","đang co giật","lú lẫn nặng"],
    "overview":["tiểu đường là gì","phân biệt típ 1 và típ 2","đái tháo đường có mấy loại","nguyên nhân của bệnh","vì sao mắc bệnh"],
    "care":["theo dõi tại nhà","tái khám khi nào","lập kế hoạch chăm sóc","ghi nhật ký đường huyết","sinh hoạt hằng ngày","tôi cần làm gì tiếp theo","bắt đầu đi bộ sau bữa tối","tập thể dục và theo dõi đường huyết khi vận động"],
}
EXAMPLES["complication"] += ["albumin niệu và chức năng thận", "kiểm tra lòng bàn chân mỗi ngày", "khám mắt giãn đồng tử và võng mạc"]
EXAMPLES["test"] += ["nhịn ăn trước khi đo HbA1c", "A1c phản ánh đường huyết mấy tháng"]
EXAMPLES["medicine"] += ["metformin gây tác dụng phụ gì", "quên uống metformin"]
EXAMPLES["overview"] += ["phòng ngừa hoặc trì hoãn típ 2", "hút thuốc lá và nguy cơ mắc bệnh"]
EXAMPLES["pregnancy"] += ["tầm soát thai kỳ tuần nào", "mang thai làm nghiệm pháp dung nạp glucose"]
HOLDOUT={"food":"nên chọn thực phẩm nào cho bữa ăn","medicine":"tôi có nên đổi thuốc uống","symptom":"bệnh có dấu hiệu và biểu hiện gì","complication":"bệnh có biến chứng ở mắt không","test":"tôi muốn xét nghiệm HbA1c","pregnancy":"nếu tôi đang mang thai thì sao","low":"nghi bị hạ đường huyết","urgent":"người nhà bị co giật","overview":"bệnh có mấy típ","care":"cách tự chăm sóc tại nhà"}
STOP=set("toi co la cua cho xin gi khong the nao thi va bi benh nhung duoc ve khi nguoi voi hay nhan ban mot nay duong tieu dai thao nen".split())

def norm(q):
    q=unicodedata.normalize("NFD",q.lower().replace("đ","d"))
    return " ".join(re.findall(r"[a-z0-9]+","".join(c for c in q if unicodedata.category(c)!="Mn")))

def tokens(q):
    ws=norm(q).split()
    return set(w for w in ws if w not in STOP) | set(" ".join(ws[i:i+2]) for i in range(len(ws)-1))

class Policy:
    def __init__(self, data):
        self.words={w:i for i,w in enumerate(data["words"])}
        self.actions=data["actions"]
        self.weights=np.array(data["weights"])

    def rank(self,q):
        ids=[self.words[t] for t in sorted(tokens(q)) if t in self.words]
        if not ids:
            return []
        scores=self.weights[ids].sum(0)/len(ids)**.5
        return [(self.actions[i],float(scores[i])) for i in np.argsort(-scores) if scores[i]>.08]

def train():
    rng=np.random.default_rng(27)
    actions=list(EXAMPLES)
    words=sorted(set.union(*(tokens(q) for seq in EXAMPLES.values() for q in seq)))
    vocab={w:i for i,w in enumerate(words)}
    events=[(np.array(sorted(vocab[t] for t in tokens(q))),i) for i,a in enumerate(actions) for q in EXAMPLES[a]]
    weights=np.zeros((len(words),len(actions)))
    # Epsilon-greedy exploration; chỉ cập nhật hành động đã chọn theo thưởng đúng/sai.
    for epoch in range(300):
        for j in rng.permutation(len(events)):
            ids,gold=events[j]
            scale=len(ids)**.5
            values=weights[ids].sum(0)/scale
            act=int(rng.integers(len(actions))) if rng.random()<.35 else int(values.argmax())
            reward=1 if act==gold else -1
            weights[ids,act]+=.12*(reward-values[act])/scale
    d=dict(actions=actions,words=words,weights=weights.round(6).tolist(),examples=len(events),epochs=300)
    policy=Policy(d)
    d["holdout"]={k:(policy.rank(q) or [("unknown",0)])[0][0] for k,q in HOLDOUT.items()}
    (HERE/"policy.json").write_text(json.dumps(d,ensure_ascii=False),encoding="utf8")

if __name__=="__main__":
    train()


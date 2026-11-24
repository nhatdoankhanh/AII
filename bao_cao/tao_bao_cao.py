"""Tạo PDF báo cáo bằng ReportLab với kết quả đã huấn luyện."""
import json
from pathlib import Path
from xml.sax.saxutils import escape
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen.canvas import Canvas
from reportlab.platypus import Paragraph, Table, TableStyle
from reportlab.lib.utils import ImageReader

ROOT=Path(__file__).resolve().parents[1]
OUT=Path(__file__).with_name("Bao_cao_cap_nhat_RAG.pdf")
for name,file in [("Body","segoeui.ttf"),("Bold","segoeuib.ttf"),("Title","segoeuisl.ttf")]:
    pdfmetrics.registerFont(TTFont(name,"C:/Windows/Fonts/"+file))
style=ParagraphStyle("body",fontName="Body",fontSize=10.5,leading=16,textColor=colors.HexColor("#233b32"))
W,H=A4
c=Canvas(str(OUT),pagesize=A4)
c.setTitle("Hệ thống sàng lọc và tư vấn đái tháo đường")
m=json.loads((ROOT/"artifacts/metrics.json").read_text(encoding="utf8"))
green="#17543f"
def header(n,title):
    c.setFillColor(green); c.setFont("Bold",10);c.drawString(42,H-42,"SỔ TAY ĐƯỜNG HUYẾT   /   BÁO CÁO THỰC NGHIỆM")
    c.setFont("Title",23);c.setFillColor(colors.black);c.drawString(42,H-87,title)
    c.setFont("Body",9);c.setFillColor(green);c.drawRightString(W-40,23,f"Đề 27    /    {n}")
def para(text,y):
    p=Paragraph(text,style);_,h=p.wrap(W-84,H);p.drawOn(c,42,y-h);return y-h-12
def head(text,y):
    c.setFillColor(green);c.setFont("Bold",14);c.drawString(42,y-15,text);return y-24
def table(rows,widths,y):
    t=Table(rows,colWidths=widths)
    t.setStyle(TableStyle([("FONTNAME",(0,0),(-1,-1),"Body"),("FONTNAME",(0,0),(-1,0),"Bold"),("FONTSIZE",(0,0),(-1,-1),9),("BACKGROUND",(0,0),(-1,0),colors.HexColor("#dcebe0")),("ROWBACKGROUNDS",(0,1),(-1,-1),[colors.white,colors.HexColor("#f2f6f1")]),("TOPPADDING",(0,0),(-1,-1),7),("BOTTOMPADDING",(0,0),(-1,-1),7)]));_,h=t.wrap(W-84,H);t.drawOn(c,42,y-h);return y-h-15
def chart(file,y,width,height):
    p=ROOT/"artifacts/charts"/file
    iw,ih=ImageReader(str(p)).getSize();k=min(width/iw,height/ih)
    c.drawImage(str(p),(W-iw*k)/2,y-ih*k,iw*k,ih*k);return y-ih*k-14
def percent(n):
    return f"{100*n:.1f}%".replace(".",",")
header(1,"Sàng lọc và tư vấn đái tháo đường")
y=para("Hệ thống kết hợp một mạng học sâu cho dữ liệu dạng bảng với kho tri thức y khoa có dẫn nguồn. Giao diện chạy trên máy cá nhân và tư vấn bằng tiếng Việt sau khi nhận kết quả sàng lọc.",H-113)
y=head("Một mô hình cho ba bộ dữ liệu",y)
y=para("Mỗi kiến trúc học một biểu diễn chung với hai đầu ra. Đầu ra thứ nhất tính điểm sàng lọc từ hồ sơ xét nghiệm hoặc bảng hỏi. Đầu ra thứ hai gợi ý một trong 12 thể bệnh khi hồ sơ chuyên sâu đủ thông tin. Bộ 04 có nhãn tiền tiểu đường riêng và chỉ các mẫu có nhãn thể bệnh mới tham gia huấn luyện đầu ra thứ hai.",y)
rows=[["Nguồn","Dòng gốc","Mẫu dùng","Train","Validation","Test"]]
for s,a in m["data"].items():
    rows.append([s,str(a["raw"]),str(a["used"]),*[str(z) for z in a["split"]]])
y=table(rows,[60,80,80,85,100,100],y)
y=para("Bộ 01 dùng tuổi, BMI, tiền sử bệnh, giới tính, HbA1c và glucose. Bộ 03 dùng nhóm tuổi khảo sát, BMI, giới tính, vận động, cholesterol và tiền sử bệnh. Bộ 04 dùng tuổi, BMI, glucose, vòng eo và sáu thuộc tính tiền sử hoặc xét nghiệm chuyên sâu. Bộ 02 trùng toàn bộ 96.146 tổ hợp phân biệt của chín cột chung với bộ 01.",y)
y=head("Diễn giải kết quả",y)
y=para("Điểm sàng lọc là đầu ra sigmoid của mô hình. Ngưỡng được chọn riêng cho mỗi chế độ trên validation. Accuracy là tỷ lệ dự đoán đúng trên toàn bộ tập test tương ứng. Dữ liệu ghi nhận tình trạng hiện tại và chưa cung cấp thời gian theo dõi để ước tính khả năng mắc bệnh trong tương lai.",y)
y=para("Không có mã định danh bệnh nhân xuyên bộ dữ liệu để kiểm định hai bước liên tiếp trên cùng một người. Các chỉ số dưới đây đánh giá từng đầu ra trên tập test nội bộ. Khả năng áp dụng cho người bệnh thực tế cần dữ liệu độc lập và thẩm định lâm sàng.",y);c.showPage()
header(2,"Dữ liệu và phương pháp huấn luyện")
y=para("Loại dòng trùng hoàn toàn trong từng bộ. Bộ 03 dùng nhãn 0 và 2 cho bài toán sàng lọc; loại nhãn 1 (tiền tiểu đường). Giá trị khuyết được biểu diễn bằng mặt nạ. Trị trung bình và độ lệch chuẩn chỉ được tính trên tập train.",H-112)
y=chart("01-phan-bo.png",y,510,165)
y=para("Hồ sơ có cùng toàn bộ đầu vào sau ánh xạ được xếp cùng một tập bằng hàm băm. Tỷ lệ chia mục tiêu là 70/15/15. Cách chia này giảm rò rỉ từ mẫu trùng đặc trưng nhưng không thể loại trừ hoàn toàn việc cùng một người xuất hiện ở nhiều dòng.",y)
y=chart("02-tuong-quan.png",y,360,205)
y=head("Học có giám sát với nhãn từng phần",y)
y=para("MLP gồm các tầng tuyến tính và SiLU. ResNet dùng hai khối có kết nối tắt. Gated thêm cổng sigmoid điều chỉnh phần thông tin từ nhánh dư. Mỗi mô hình chạy 10 epoch với AdamW, tốc độ học 0,0015 và seed 27. Mỗi batch lấy mẫu từ cả ba nguồn; loss là trung bình hai binary cross-entropy và một cross-entropy đa lớp.",y);c.showPage()
header(3,"So sánh mô hình và kết quả sàng lọc")
y=para("Điểm chọn mô hình là trung bình của balanced accuracy bộ 01, balanced accuracy bộ 03 và macro-F1 bộ 04 trên validation. Ngưỡng sàng lọc tối đa hóa Youden J trên validation. Chỉ checkpoint được chọn mới dùng để báo cáo test.",H-112)
y=table([["Kiến trúc","Epoch tốt nhất","Điểm validation"]]+[[k,str(v["epoch"]),f'{v["score"]:.4f}'] for k,v in m["candidates"].items()],[170,160,175],y)
y=chart("03-so-sanh.png",y,425,160)
y=table([["Đầu ra test","Accuracy","Balanced accuracy","Macro-F1"]]+[[label,percent(m["test"][k]["accuracy"]),percent(m["test"][k]["balanced_accuracy"]),percent(m["test"][k]["macro_f1"])] for k,label in [("lab","Xét nghiệm"),("survey","Bảng hỏi"),("type","Thể bệnh")]],[136,100,150,119],y)
y=chart("04-sang-loc.png",y,440,163)
para("Các ô là số hồ sơ. Màu thể hiện tỷ lệ trong từng hàng nhãn thực. Bảng hỏi có nhiều ca phân loại sai hơn hồ sơ có xét nghiệm; hai tập kiểm tra đến từ hai quần thể và có đầu vào khác nhau.",y);c.showPage()
header(4,"Phân loại thể bệnh")
y=para("Đầu ra softmax học từ những hồ sơ có nhãn thể bệnh trong bộ 04. Sau sàng lọc dương, hệ thống kiểm tra đủ trường chuyên sâu và chỉ hiển thị gợi ý khi điểm lớp cao nhất đạt 0,55. Đây là ngưỡng vận hành chọn cho demo. Accuracy đa lớp được tính trên toàn bộ tập test bộ 04, trước khi áp dụng ngưỡng này.",H-112)
y=chart("05-the-benh.png",y,450,300)
names=["CFRD (liên quan xơ nang)","Đái tháo đường thai kỳ","LADA","MODY","Đái tháo đường sơ sinh","Đái tháo đường thứ phát","Đái tháo đường do steroid","Đái tháo đường típ 1","Đái tháo đường típ 2","Đái tháo đường típ 3c","Hội chứng Wolcott–Rallison","Hội chứng Wolfram"]
# Lấy đúng thứ tự lớp từ checkpoint.
lookup=dict(zip(["Cystic Fibrosis-Related Diabetes (CFRD)","Gestational Diabetes","LADA","MODY","Neonatal Diabetes Mellitus (NDM)","Secondary Diabetes","Steroid-Induced Diabetes","Type 1 Diabetes","Type 2 Diabetes","Type 3c Diabetes (Pancreatogenic Diabetes)","Wolcott-Rallison Syndrome","Wolfram Syndrome"],names))
ordered=[lookup[k] for k in m["classes"]]
y=table([["Mã","Thể bệnh","Mã","Thể bệnh"]]+[[str(i),ordered[i],str(i+6),ordered[i+6]] for i in range(6)],[36,214,36,219],y)
para("Một số nhóm thứ phát và típ 3c có đặc trưng tương tự trong bộ 04. Nguồn gốc lâm sàng và đơn vị của một số cột bộ 04 chưa được xác nhận; giao diện ghi rõ vòng eo theo thang số bộ dữ liệu. Không dùng nhãn gợi ý để tự chọn thuốc.",y);c.showPage()
header(5,"Tri thức và quy trình tư vấn")
y=head("Xây dựng đồ thị",H-113)
y=para("Từ 18 trang web và hai tài liệu PDF, dự án biên soạn 37 mệnh đề tiếng Việt có thể truy về cơ quan xuất bản, URL và mục gốc. Mỗi mệnh đề liên kết với một chủ đề (ABOUT), một khái niệm (DESCRIBES) và một nguồn (CITES). File kb_diabet.cypher có các ràng buộc duy nhất và dùng MERGE để tái tạo đồ thị.",y)
y=head("Học tăng cường và ba agent",y)
y=para("Contextual bandit biểu diễn câu hỏi bằng từ đơn và cặp từ tiếng Việt đã chuẩn hóa. Hành động là chọn một trong 10 chủ đề. Khi huấn luyện offline, phần thưởng là +1 nếu chọn trúng chủ đề được gán, −1 nếu chọn sai. Chính sách epsilon-greedy cập nhật giá trị hành động đã chọn trong 300 lượt qua tập ví dụ.",y)
y=para("Agent truy xuất hỏi Neo4j theo chủ đề. Agent tư vấn gửi câu hỏi, kết quả dự đoán và các mệnh đề cho Qwen3-8B qua Ollama local. Qwen chọn thứ tự bằng chứng; agent kiểm tra chỉ cho hiển thị nội dung đã duyệt với URL hợp lệ trong danh mục. Rule khẩn cấp và quy tắc thuốc được áp dụng trước khi trả lời.",y)
y=para("Khi mất kết nối đồ thị, giao diện ghi rõ truy xuất từ bản sao tri thức cục bộ. Nếu Qwen không trả cấu trúc hợp lệ, giao diện hiển thị mệnh đề đã duyệt và ghi rõ nguồn sinh câu trả lời. Tab Kho tri thức hiển thị số mệnh đề Neo4j thực tế, model Ollama và số PDF gốc trên máy.",y)
y=head("Kịch bản trình diễn",y)
y=para("Mở Sàng lọc, chọn Mẫu có nguy cơ và xem kết quả. Đây là hồ sơ minh họa với tuổi 49, BMI 38, HbA1c 6,8% và glucose 150 mg/dL cùng các trường chuyên sâu điền sẵn. Xem điểm, ngưỡng, accuracy test và thể bệnh gợi ý. Thử bỏ một trường chuyên sâu để thấy thông báo thiếu dữ liệu.",y)
y=para("Hỏi “Nên ăn gì?” rồi mở nguồn cạnh câu trả lời. Tiếp theo hỏi về thuốc hoặc biến chứng. Mở Kho tri thức để tra cứu chủ đề và kiểm tra backend. Cuối cùng mở Thực nghiệm để đối chiếu ba kiến trúc và năm biểu đồ.",y);c.showPage()
header(6,"Nguồn tri thức và dữ liệu")
y=para("Nhấn vào tên tài liệu để mở nguồn. Danh sách URL đầy đủ được lưu trong sources/links.txt và sources/pdf/sources.txt. Các nguồn này cung cấp tri thức tư vấn; bộ dữ liệu trong Data cung cấp mẫu cho mô hình dự đoán.",H-112)
for f in ["links.txt","pdf/sources.txt"]:
    lines=(ROOT/"sources"/f).read_text(encoding="utf8").splitlines()
    y=head("Nguồn web" if f=="links.txt" else "Tài liệu PDF",y)
    for label,url in zip(lines[::2],lines[1::2]):
        parts=label.split(" | ")
        y=para('<link color="#17543f" href="'+escape(url)+'">'+escape(" · ".join(parts[:3]))+'</link>',y+4)
y=head("Tài liệu đối chiếu mã khảo sát",y)
para('<link color="#17543f" href="https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators">UCI Machine Learning Repository · CDC Diabetes Health Indicators</link>. Ba tệp CSV huấn luyện được cung cấp trong thư mục dự án. Nguồn gốc và phương pháp thu thập bộ 01 và 04 cần đối chiếu thêm trước khi khái quát kết quả.',y)
c.showPage();c.save()


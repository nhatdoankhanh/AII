# Sổ tay đường huyết

Ứng dụng Windows chạy tại **http://127.0.0.1:7860/**. Mô hình dự đoán đã huấn luyện nằm ở `artifacts/model.pt`. Chatbot dùng **Qwen3-8B** qua Ollama cục bộ. Mở **Nguồn và cách trả lời** để xem các đoạn trích và nguồn tham khảo. Báo cáo trình bày kết quả tại [bao_cao/Bao_cao_cap_nhat_RAG.pdf](bao_cao/Bao_cao_cap_nhat_RAG.pdf).

## Mở demo

1. Nhấp đúp **chay-demo.cmd**. Trên máy đã chuẩn bị, chương trình khởi động dịch vụ cục bộ và mở trình duyệt. Để chạy ứng dụng trong terminal, mở PowerShell tại thư mục dự án rồi chạy `python main.py`.
2. Trong bảng **Hồ sơ sàng lọc** bên phải, chọn **Nạp hồ sơ mẫu → Mẫu có nguy cơ → Tính ước tính**. Trên điện thoại, chạm **Hồ sơ** để mở bảng. Hồ sơ minh họa có điểm 98,6% và mô hình gợi ý típ 2.
3. Chờ trợ lý trả lời câu hỏi đầu tiên tự động, rồi chọn **Nên ăn gì?**. Mỗi đoạn có đường dẫn nguồn và thông tin về agent, nguồn truy xuất, model thực sự đã dùng. Câu hỏi về thuốc nhận thông tin tham khảo, việc chọn thuốc và liều cá nhân cần bác sĩ.
4. Mở **Thực nghiệm** để xem so sánh mô hình và 5 biểu đồ. Trong **Kho tri thức → Tra cứu đoạn nguồn**, nhập câu hỏi (ví dụ `HbA1c có cần nhịn ăn?`) rồi nhấn **Tìm**. Có thể thu hẹp theo chủ đề hoặc để trống từ khóa để duyệt toàn bộ các đoạn của chủ đề. Mỗi kết quả có đoạn trích, mục tài liệu và liên kết nguồn. Tra cứu chạy cục bộ, dùng được trước khi nhập hồ sơ và khi Ollama ngoại tuyến.

Ứng dụng nạp mô hình sàng lọc vào lần tính đầu tiên và khởi tạo bộ tìm kiếm ở lượt chat hoặc tra cứu từ khóa đầu tiên. Khi kết nối Neo4j thất bại, các lượt tra cứu trong 15 giây tiếp theo dùng bản sao cục bộ. Nhấn **Kiểm tra lại** để thử kết nối ngay và cập nhật nguồn đang dùng.

Thanh bên trái cho phép tạo, mở lại và xóa cuộc trò chuyện. Hồ sơ, kết quả, tin nhắn và nguồn được lưu vào SQLite tại `local/conversations.sqlite3`. Hãy dùng cùng trình duyệt và địa chỉ truy cập để mở lại lịch sử. Trợ lý dùng các lượt gần đây và một lượt cũ liên quan trong cùng cuộc trò chuyện khi chọn bằng chứng. Ví dụ, sau khi hỏi về metformin, bạn có thể hỏi tiếp “Thuốc đó có gây đau bụng không?”.

**Cấu hình RAM cho Qwen3-8B.** Ứng dụng dùng ngữ cảnh 4.096 token, xử lý đầu vào theo lô 128 token và yêu cầu Ollama giải phóng mô hình sau một phút rảnh. Các giá trị này nằm trong `config/llm.json`. Khi hai tệp CMD của dự án khởi động Ollama, chúng dùng `config/ollama-demo.cmd` để bật KV cache 8-bit, giới hạn bộ đệm của các prompt cũ ở 128 MiB và chạy một yêu cầu mỗi lần. Nếu Ollama đã chạy riêng, hãy thoát Ollama rồi mở `chay-demo.cmd` để bản portable nhận các thiết lập máy chủ.

**Tin nhắn và lịch sử dài.** Giao diện tải 30 sự kiện gần nhất khi mở một cuộc trò chuyện. Chọn **Xem tin nhắn cũ hơn** để đọc tiếp lịch sử.

Ô chat nhận tối đa 4.000 ký tự. Khi gửi câu hỏi, máy chủ đọc lịch sử từng lượt và giữ một số lượt liên quan trong RAM. Trước mỗi lần gọi Qwen, ứng dụng dùng số byte UTF-8 làm giới hạn trên cho số token của nội dung, chừa chỗ cho mẫu chat và câu trả lời, rồi giảm lịch sử và đoạn nguồn nếu cần. Nếu câu hỏi nguyên vẹn cùng bằng chứng vẫn vượt ngân sách, ứng dụng hiển thị trích dẫn cục bộ.

Trong `config/llm.json`, ngưỡng RAM khả dụng mặc định là 5 GiB khi cần nạp Qwen và 1 GiB khi Ollama xác nhận mô hình đã nạp với đúng cửa sổ ngữ cảnh. Mỗi lần gọi mô hình có tối đa 10 phút để hoàn tất. Khi RAM xuống dưới ngưỡng, trợ lý dùng kho trích dẫn để bảo vệ máy. Nhật ký `local/demo-errors.log` của bản demo ghi số token đầu vào do Ollama trả về, thời gian của lượt gọi thành công và lý do chuyển sang trích dẫn.

## Chuẩn bị đủ thành phần trên Windows

Python 3.10 và Java 17 hoặc 21. Nếu dùng môi trường Python mới, chạy `python -m pip install -r requirements.txt`.

- **Qwen3-8B**. Trên máy mới, nhấp đúp `tai-qwen3-8b.cmd` để tải và chạy thử mô hình. Bản portable dùng `local/ollama` và `local/models`.
- **Neo4j và hai PDF gốc**. Chạy lệnh dưới đây trong PowerShell trên máy có Internet. Script tải từ trang phát hành, chuẩn bị Neo4j Community 5.26.0 tại `local`, lưu hai PDF vào `sources/pdf` và nạp đồ thị. Có thể chạy lại sau khi kết nối được khôi phục.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "D:\AI\chuan-bi-neo4j.ps1"
```

Khi lệnh báo `Neo4j: 37 facts`, mở **Kho tri thức → Kiểm tra lại**. Để nghiệm thu đầy đủ, kiểm tra **Neo4j 37/37**, **PDF 2/2** và **Qwen3-8B sẵn sàng**. Khi chưa kết nối Neo4j, ứng dụng ghi rõ đang truy xuất bản sao cục bộ. Khi Qwen không phản hồi hoặc trả danh sách bằng chứng không hợp lệ, ứng dụng hiển thị các đoạn đã duyệt với nhãn “Trích dẫn cục bộ”.

Neo4j Browser của bản demo ở **http://localhost:17474/browser/**. Kết nối Bolt `bolt://localhost:17687`, người dùng `neo4j`; mật khẩu tự tạo nằm trong `local/neo4j-password.txt`. Chạy từng câu trong [knowledge_base/demo.cypher](knowledge_base/demo.cypher). Để dùng Neo4j 5.x có sẵn, đặt biến môi trường `NEO4J_HTTP`, `NEO4J_USER`, `NEO4J_PASSWORD` rồi chạy `python -m knowledge_base.graph --load`. Tệp [kb_diabet.cypher](knowledge_base/kb_diabet.cypher) cũng có thể nạp bằng cypher-shell.

## Huấn luyện và tái tạo

Từ thư mục dự án, chạy các lệnh dưới đây cho phần muốn tái tạo.

```powershell
python -m deep_learning.train
python -m agents.policy
python -m knowledge_base.graph --load
```

Huấn luyện dùng bộ 01, 03, 04, loại trùng trước khi chia tập. Các hồ sơ có cùng vector đầu vào nằm cùng một tập. Mỗi kiến trúc có một phần mạng chung, đầu ra sàng lọc và đầu ra phân loại thể bệnh. Mỗi batch có dữ liệu của cả ba nguồn. Mẫu có nhãn tiền tiểu đường của bộ 03 và 04 được loại trong cấu hình nhị phân/phân thể hiện tại. Điểm sàng lọc mô tả kết quả nội bộ của mô hình; dự án chưa hiệu chuẩn xác suất trên quần thể lâm sàng.

[Chỉ số đầy đủ](artifacts/metrics.json) gồm số mẫu, ngưỡng, kết quả validation và test, thứ tự lớp và các ma trận nhầm lẫn. Các biểu đồ dùng đúng lần huấn luyện này. Khởi động lại tiến trình web sau khi huấn luyện lại để nạp checkpoint mới.

## Cấu trúc

| Đường dẫn | Nội dung |
|---|---|
| `Data/`, `deep_learning/`, `artifacts/` | CSV, huấn luyện, mô hình chung, chỉ số và 5 biểu đồ |
| `knowledge_base/` | 37 mệnh đề có mục nguồn, tạo Cypher, truy vấn và nạp Neo4j |
| `agents/` | Chính sách contextual bandit, agent truy xuất, agent tư vấn Qwen, agent kiểm tra |
| `sources/` | Danh mục 18 URL web, 2 URL PDF và thư mục chứa các PDF gốc |
| `interface/`, `main.py` | Giao diện và API local |
| `bao_cao/` | Báo cáo PDF và chương trình tạo báo cáo trên Windows bằng ReportLab |

Bộ câu hỏi dùng huấn luyện bandit và 10 câu kiểm tra minh họa nằm trong `agents/policy.py`. Dữ liệu thử nhỏ, do dự án tự soạn. Các ví dụ chat cần đánh giá thêm trước khi dùng cho người bệnh.



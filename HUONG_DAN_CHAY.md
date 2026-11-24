# Hướng dẫn chạy Diabetes Research AI

Ứng dụng chạy cục bộ trên máy tính, gồm giao diện Flask, chatbot Qwen3-8B qua Ollama, bộ tìm kiếm tri thức, SQLite và mô hình sàng lọc. Địa chỉ giao diện mặc định là `http://127.0.0.1:7860/`.

## Cách nhanh trên Windows

1. Cài Python 3.10 và Java 17 hoặc Java 21.
2. Mở thư mục dự án và chạy `tai-qwen3-8b.cmd`. Lần đầu, chương trình tải Ollama portable và mô hình `qwen3:8b`, sau đó chạy thử Qwen.
3. Nhấp đúp `chay-demo.cmd`. Chương trình khởi động Ollama và Flask rồi mở giao diện trong trình duyệt.

Nếu các thành phần đã có sẵn, chỉ cần chạy bước 3. Lần đầu chạy, Ollama cần vài giây để nạp mô hình vào RAM.

## Chạy trên Windows bằng PowerShell

Mở PowerShell tại thư mục dự án:

```powershell
python -m pip install -r requirements.txt
python main.py
```

Mở `http://127.0.0.1:7860/`. Lệnh `python main.py` giữ máy chủ ở cửa sổ terminal hiện tại. Nhấn `Ctrl+C` để dừng.

Để chuẩn bị Neo4j Community, tải hai PDF gốc và nạp đồ thị tri thức, chạy trên máy có quyền truy cập Internet:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\chuan-bi-neo4j.ps1
```

Script tự tải và cài Neo4j Community 5.26.0 vào `local/neo4j-community-5.26.0`, tạo mật khẩu ban đầu trong `local/neo4j-password.txt`, cấu hình cổng HTTP `17474` và Bolt `17687`, khởi động Neo4j, rồi nạp các nguồn tri thức. Hãy giữ đúng thư mục dự án để script tìm thấy các tệp cấu hình. Cần Java 17 hoặc 21 và Internet ở lần cài đầu.

Kiểm tra trạng thái trong giao diện **Kho tri thức → Kiểm tra lại** hoặc mở `http://127.0.0.1:7860/api/status`. Neo4j sẵn sàng khi trường `neo4j` bằng số mục tri thức, hiện là 71. Mở Neo4j Browser tại `http://localhost:17474/browser/`, kết nối `bolt://localhost:17687` bằng tên người dùng `neo4j` và mật khẩu trong `local/neo4j-password.txt`.

Nếu Neo4j Community 5.x đã được cài và chạy riêng, đặt các biến môi trường để ứng dụng gọi HTTP transactional endpoint. Dùng mật khẩu của chính cơ sở dữ liệu đó:

```powershell
$env:NEO4J_HTTP = "http://127.0.0.1:7474"
$env:NEO4J_USER = "neo4j"
$env:NEO4J_PASSWORD = "mat-khau-cua-ban"
python -m knowledge_base.graph --load
python main.py
```

Nếu cơ sở dữ liệu chạy với cổng HTTP demo `17474`, thay `7474` bằng `17474`. Lệnh nạp dùng `MERGE`, nên có thể chạy lại để thêm các mục mới. Không cần chạy nạp cho mỗi lần mở ứng dụng. Khi Neo4j dừng, ứng dụng chuyển tự động sang bản sao tri thức JSON cục bộ.

## Chạy bằng Bash

Cài Python 3.10, Java 17 hoặc 21, Git, `curl` và `unzip`. Mở Bash tại thư mục dự án:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

Bản Bash có thể dùng Ollama đã cài sẵn. Kéo mô hình và đặt cấu hình máy chủ:

```bash
ollama pull qwen3:8b
export OLLAMA_HOST=127.0.0.1:11434
export OLLAMA_MODELS="$PWD/local/models"
export OLLAMA_CONTEXT_LENGTH=4096
export OLLAMA_NUM_PARALLEL=1
export OLLAMA_MAX_LOADED_MODELS=1
export OLLAMA_FLASH_ATTENTION=1
export OLLAMA_KV_CACHE_TYPE=q8_0
export LLAMA_ARG_CACHE_RAM=128
ollama serve
```

Giữ terminal này chạy Ollama. Mở terminal Bash thứ hai tại thư mục dự án, kích hoạt môi trường ảo nếu cần, rồi chạy Flask:

```bash
export OLLAMA_HOST=127.0.0.1:11434
export OLLAMA_MODELS="$PWD/local/models"
python main.py
```

Mở `http://127.0.0.1:7860/`. Ollama tự giải phóng mô hình theo cấu hình `keep_alive` trong `config/llm.json`.

Có thể mở dịch vụ Neo4j tương thích Bolt/HTTP riêng và đặt các biến trước khi chạy ứng dụng:

```bash
export NEO4J_HTTP=http://127.0.0.1:17474
export NEO4J_USER=neo4j
export NEO4J_PASSWORD='mat-khau-cua-ban'
python -m knowledge_base.graph --load
```

Địa chỉ trên phải là cổng HTTP transactional của Neo4j. Cổng Bolt dành cho Neo4j Browser và driver, không dùng làm `NEO4J_HTTP`. Nếu cần, khởi động ứng dụng trong cùng terminal để giữ các biến môi trường:

```bash
python main.py
```

Mở `http://127.0.0.1:7860/api/status` và xác nhận `neo4j` bằng số mục đã nạp. Bản cài Windows đi kèm dùng `http://127.0.0.1:17474` cho HTTP và `bolt://localhost:17687` cho Bolt. Tài liệu trong `knowledge_base/passages/` cùng các mệnh đề nền trong `knowledge_base/facts.json` sẽ được nạp vào đồ thị khi chạy `python -m knowledge_base.graph --load`.

## Sử dụng và cấu hình

- Hoàn tất hồ sơ sàng lọc để bắt đầu chat. Dùng nút **Tìm kiếm trực tuyến · Bật/Tắt** để chọn tìm nguồn web cho các câu hỏi ngoài kho. Khi tắt, ứng dụng dùng Qwen với nhãn câu trả lời chưa được kho kiểm chứng.
- Ô chat hỗ trợ tối đa 4.000 ký tự. Lịch sử dài được tải từng trang, 30 mục mỗi lần.
- Qwen dùng cửa sổ 4.096 token và tối đa một yêu cầu đồng thời. Ứng dụng giới hạn ngân sách đầu vào, kiểm tra RAM trước khi gọi mô hình và chờ tối đa 10 phút. Chỉnh các giá trị tại `config/llm.json` và `config/ollama-demo.cmd`.
- Các đoạn nguồn WHO và CDC được lưu tại `knowledge_base/passages/WHO-CDC-2026.json` và hoạt động khi ngoại tuyến. Nguồn cùng URL nằm trong `sources/links.txt`.
- Hội thoại được lưu cục bộ tại `local/conversations.sqlite3`. Nhật ký chạy nằm tại `local/demo-errors.log` và `local/ollama-startup.log`.
- Ollama có thể kiểm tra bằng `curl http://127.0.0.1:11434/api/version`. API ứng dụng là `http://127.0.0.1:7860/api/status`.

## Cấu trúc dữ liệu tri thức

Các đoạn nền nằm trong `knowledge_base/facts.json`. Tài liệu nhập bằng `knowledge_base/ingest.py` được lưu thành JSON trong `knowledge_base/passages/`. Mỗi đoạn ghi ID, nguồn, chủ đề, khái niệm, nội dung và mục tài liệu. Sau khi thêm nguồn mới, nạp lại chỉ mục Neo4j khi Neo4j đã hoạt động:

```bash
python -m knowledge_base.graph --load
```

## Khắc phục lỗi nhanh

- Không mở được giao diện: kiểm tra tiến trình Flask và chạy lại `python main.py` hoặc `chay-demo.cmd`.
- Ollama mất kết nối: khởi động `ollama serve`, sau đó kiểm tra `/api/version` và `/api/tags`.
- Ollama có model nhưng phản hồi chậm: lần gọi đầu tiên cần nạp Qwen. Kiểm tra RAM trống và `local/ollama-startup.log`.
- Neo4j không kết nối: ứng dụng sẽ dùng bản sao cục bộ. Kiểm tra `NEO4J_HTTP`, tài khoản và mật khẩu nếu cần dùng đồ thị.
- Thiếu gói Python: cài lại bằng `python -m pip install -r requirements.txt`.

## Đẩy tài liệu lên GitHub

Từ kho Git đã cấu hình remote:

```bash
git add HUONG_DAN_CHAY.md
git commit -m "Add Vietnamese run guide"
git push
```

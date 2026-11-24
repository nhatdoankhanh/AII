"""Import a named HTML section or a physical PDF page from the source catalog."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
from tempfile import NamedTemporaryFile, TemporaryDirectory
from textwrap import wrap

import requests
from bs4 import BeautifulSoup

from .graph import FACTS, HERE, SOURCES


def html_section(data, heading):
    soup = BeautifulSoup(data, "html.parser")
    article = soup.select_one("main") or soup.select_one("article") or soup
    def title(tag):
        return " ".join(tag.stripped_strings)
    headings = re.compile("^h[1-6]$")
    for start in article.find_all(headings):
        if title(start).casefold() != heading.casefold():
            continue
        paragraphs = []
        for node in start.find_all_next([*("h"+str(i) for i in range(1,7)), "p", "li"]):
            if article not in node.parents and article is not soup:
                break
            if headings.match(node.name) and node.name <= start.name:
                break
            if node.find_parent(["nav","footer","aside"]) or node.find(["li","p"]):
                continue
            paragraphs.append(title(node))
        return "\n".join(paragraphs)
    raise ValueError("Không tìm thấy tiêu đề HTML: "+heading)


def pdf_page(data, page):
    if page < 1 or not data.startswith(b"%PDF"):
        raise ValueError("Cần dữ liệu PDF và số trang bắt đầu từ 1.")
    if shutil.which("pdftotext"):
        with TemporaryDirectory() as tmp:
            path = Path(tmp)/"source.pdf"
            path.write_bytes(data)
            result = subprocess.run(["pdftotext","-f",str(page),"-l",str(page),"-enc","UTF-8",
                                     str(path),"-"], capture_output=True, check=True)
            return result.stdout.decode("utf8")
    from io import BytesIO
    from pypdf import PdfReader
    return PdfReader(BytesIO(data)).pages[page-1].extract_text()


def import_section(source, topic, concept, location, text, destination):
    text = " ".join(text.split())
    if not text:
        raise ValueError("Mục này chưa có văn bản có thể trích xuất.")
    key = hashlib.sha256((source+"|"+location).encode()).hexdigest()[:16]
    chunks, current = [], ""
    for sentence in re.split(r"(?<=[.!?])\s+", text):
        if len(current)+len(sentence)>900 and current:
            chunks.append(current)
            current=""
        pieces = wrap(sentence, width=900, break_long_words=False, break_on_hyphens=False)
        chunks.extend(pieces[:-1])
        current=(current+" "+pieces[-1]).strip()
    if current:
        chunks.append(current)
    rows = []
    for i,chunk in enumerate(chunks,1):
        digest=hashlib.sha256((topic+"|"+concept+"|"+chunk).encode()).hexdigest()[:12]
        rows.append(dict(id=f"D{key}-{i}-{digest}",source=source,topic=topic,concept=concept,
                         section=location,text=chunk))
    destination.mkdir(parents=True,exist_ok=True)
    path=destination/(source+"-"+key+".json")
    with NamedTemporaryFile(mode="w",encoding="utf8",dir=destination,delete=False,suffix=".tmp") as tmp:
        json.dump(rows,tmp,ensure_ascii=False,indent=2)
    Path(tmp.name).replace(path)
    return rows


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source",required=True,choices=SOURCES)
    parser.add_argument("--topic",required=True,choices=sorted({f["topic"] for f in FACTS}))
    parser.add_argument("--concept",required=True,help="Tên khái niệm tiếng Việt dùng để tìm kiếm")
    parser.add_argument("--file",type=Path,help="Bản gốc trên máy; mặc định tải URL trong danh mục")
    where=parser.add_mutually_exclusive_group(required=True)
    where.add_argument("--section",help="Tiêu đề HTML chính xác")
    where.add_argument("--page",type=int,help="Số trang vật lý trong PDF")
    args=parser.parse_args()
    pdf=SOURCES[args.source]["format"]=="PDF"
    if pdf!=(args.page is not None):
        parser.error("Nguồn PDF dùng --page, nguồn HTML dùng --section.")
    if args.file:
        data=args.file.read_bytes()
    else:
        response=requests.get(SOURCES[args.source]["url"],timeout=30)
        response.raise_for_status()
        data=response.content
    if pdf:
        location=f"PDF tr. {args.page}"
        text=pdf_page(data,args.page)
    else:
        location=args.section
        text=html_section(data,location)
    rows=import_section(args.source,args.topic,args.concept,location,text,HERE/"passages")
    print(f"{args.source} · {location} · {len(rows)} đoạn")


if __name__=="__main__":
    main()

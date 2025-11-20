import os
from pathlib import Path
import pdfminer.high_level
import chromadb
from chromadb.utils import embedding_functions

DOCS_DIR = Path("docs")
CHROMA_PATH = "chroma_db"

def convert_pdf_to_text(pdf_path):
    txt_path = pdf_path.with_suffix(".txt")
    text = pdfminer.high_level.extract_text(str(pdf_path))
    txt_path.write_text(text, encoding="utf-8")
    print(f"[PDF → TXT] {pdf_path.name} → {txt_path.name}")
    return txt_path

def chunk_text_file(txt_path, chunk_size=800):
    chunks_path = txt_path.with_name(txt_path.stem + "_chunks.txt")
    text = txt_path.read_text(encoding="utf-8")
    
    chunks = []
    for i in range(0, len(text), chunk_size):
        chunk = text[i:i+chunk_size].strip()
        if chunk:
            chunks.append(chunk)

    with open(chunks_path, "w", encoding="utf-8") as f:
        for c in chunks:
            f.write(c + "\n---CHUNK---\n")

    print(f"[TXT → CHUNKS] {txt_path.name} → {chunks_path.name}")
    return chunks_path

def build_chroma(all_chunk_files):
    print("\n🚀 Building Chroma Vector DB...")
    chroma = chromadb.PersistentClient(path=CHROMA_PATH)

    try:
        collection = chroma.get_collection("geosafe")
    except:
        collection = chroma.create_collection(name="geosafe", metadata={"hnsw:space": "cosine"})
    
    documents = []
    ids = []

    counter = 0

    for chunk_file in all_chunk_files:
        raw = Path(chunk_file).read_text(encoding="utf-8").split("---CHUNK---")
        for chunk in raw:
            clean = chunk.strip()
            if len(clean) > 0:
                documents.append(clean)
                ids.append(str(counter))
                counter += 1

    collection.add(ids=ids, documents=documents)
    print(f"✅ Chroma DB updated! Total chunks added: {len(documents)}")

def main():
    print("🔍 Scanning for PDFs…")

    pdf_files = [p for p in DOCS_DIR.iterdir() if p.suffix.lower() == ".pdf"]

    if not pdf_files:
        print("❌ No PDFs found in docs/")
        return

    print(f"📄 Found {len(pdf_files)} PDFs.\n")

    chunk_files = []

    for pdf in pdf_files:
        txt = convert_pdf_to_text(pdf)
        chunks = chunk_text_file(txt)
        chunk_files.append(chunks)

    build_chroma(chunk_files)

    print("\n🎉 DONE! All PDFs processed and added to vector DB.")

if __name__ == "__main__":
    main()

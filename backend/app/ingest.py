import os
from pathlib import Path
import chromadb

BASE_DIR = Path(__file__).resolve().parent        # /GeoSafe/app
PROJECT_ROOT = BASE_DIR.parent                   # /GeoSafe/
DOCS_DIR = PROJECT_ROOT / "docs"
CHROMA_DIR = BASE_DIR / "chroma_db"

# Disaster → collection mapping
COLLECTIONS = {
    "flood.txt": "documents_flood",
    "cyclone.txt": "documents_cyclone",
    "drought.txt": "documents_drought",
    "general.txt": "documents_general"
}

CHUNK_SIZE = 300
CHUNK_OVERLAP = 30

def split_text(text, size=CHUNK_SIZE, overlap=CHUNK_OVERLAP):
    words = text.split()
    chunks = []
    i = 0
    while i < len(words):
        chunk = words[i:i+size]
        chunks.append(" ".join(chunk))
        i += (size - overlap)
    return chunks

def ingest():
    os.makedirs(CHROMA_DIR, exist_ok=True)
    client = chromadb.PersistentClient(path=str(CHROMA_DIR))

    for filename, coll_name in COLLECTIONS.items():
        path = DOCS_DIR / filename

        if not path.exists():
            print(f"⚠️ Missing file: {path}, skipping")
            continue

        # create collection
        collection = client.get_or_create_collection(coll_name)

        print(f"\n📘 Ingesting {filename} → {coll_name}")

        text = path.read_text(encoding="utf-8")
        chunks = split_text(text)

        print(f"  → {len(chunks)} chunks created")

        # Insert into collection
        for i, chunk in enumerate(chunks):
            collection.add(
                ids=[f"{coll_name}_{i}"],
                documents=[chunk],
                metadatas=[{"source": filename, "chunk": i}]
            )

    print("\n====== INGEST COMPLETE ======")

if __name__ == "__main__":
    ingest()

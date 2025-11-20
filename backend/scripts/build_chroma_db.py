import chromadb
from chromadb.utils import embedding_functions

chroma_client = chromadb.PersistentClient(path="chroma_db")

collection = chroma_client.create_collection(
    name="geosafe",
    metadata={"hnsw:space": "cosine"}
)

embedding_fn = embedding_functions.DefaultEmbeddingFunction()

file_path = "docs/flood_chunks.txt"

with open(file_path, "r", encoding="utf-8") as f:
    raw = f.read().split("---CHUNK---")

documents = []
ids = []

for i, chunk in enumerate(raw):
    text = chunk.strip()
    if len(text) > 0:
        documents.append(text)
        ids.append(str(i))

collection.add(
    ids=ids,
    documents=documents
)

print("Chroma DB built successfully! Stored in chroma_db/")

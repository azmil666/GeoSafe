from chromadb import PersistentClient
import os

path = "../chroma_db"
print("Chroma DB folder exists:", os.path.exists(path))

client = PersistentClient(path=path)

print("Collections found:")
for col in client.list_collections():
    print(" -", col.name)

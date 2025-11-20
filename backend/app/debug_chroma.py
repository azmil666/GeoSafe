import chromadb

client = chromadb.PersistentClient(path="chroma_db")

print("Collections:", client.list_collections())

col = client.get_collection("documents")

count = col.count()
print("Total documents:", count)

# Print first 5 items
res = col.get(limit=5)
print(res)

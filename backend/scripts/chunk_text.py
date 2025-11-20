import sys

file_path = sys.argv[1]
chunk_size = 800  # adjust if needed

with open(file_path, "r", encoding="utf-8") as f:
    text = f.read()

chunks = []
for i in range(0, len(text), chunk_size):
    chunk = text[i:i+chunk_size]
    chunks.append(chunk.strip())

out = file_path.replace(".txt", "_chunks.txt")

with open(out, "w", encoding="utf-8") as f:
    for c in chunks:
        f.write(c + "\n---CHUNK---\n")

print(f"Chunks created → {out}")

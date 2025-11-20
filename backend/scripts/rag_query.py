import sys
import chromadb
from chromadb.utils import embedding_functions
import subprocess

query = sys.argv[1]

# Load Chroma DB
chroma_client = chromadb.PersistentClient(path="chroma_db")
collection = chroma_client.get_collection("geosafe")

# Embed query & retrieve chunks
results = collection.query(
    query_texts=[query],
    n_results=3
)

chunks = results['documents'][0]

# Prepare the prompt for phi3
prompt = f"""
You are GeoSafe, an offline disaster safety assistant.

Use ONLY the following verified safety passages to answer the user question.
If the information is not in the passages, reply: "I don't have that information."

Safety Passages:
{chunks}

User Question: {query}

Answer:
"""

# Call phi3 via Ollama
process = subprocess.Popen(
    ["ollama", "run", "phi3"],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True
)

answer, _ = process.communicate(prompt)

print("\n--- GeoSafe Answer ---\n")
print(answer)

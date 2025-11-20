# ========================
# GeoSafe Backend — Updated Disaster-Aware RAG
# ========================

import os
import time
import re
from typing import List, Optional
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import chromadb

try:
    from llama_cpp import Llama
    HAVE_LLAMA = True
except:
    HAVE_LLAMA = False

# -------------------------------------
# PATHS
# -------------------------------------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CHROMA_DIR = os.path.join(BASE_DIR, "chroma_db")

MODEL_PATH = "/Users/azmilmohammed/Desktop/GeoSafe/model/ibm/granite-3.0-2b-instruct-Q4_K_M.gguf"

SYSTEM_PROMPT = """You are GeoSafe AI, an emergency guidance assistant.
Use ONLY the provided context. 
If the context does not contain the answer, say:
"I don't know based on the data I have."
"""

MAX_CONTEXT_CHARS = 2000
MAX_TOKENS = 150
TOP_K = 3

# -------------------------------------
# FASTAPI
# -------------------------------------
app = FastAPI(title="GeoSafe Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# -------------------------------------
# Pydantic Models
# -------------------------------------
class ChatRequest(BaseModel):
    message: str
    history: Optional[List[dict]] = None

class ChatResponse(BaseModel):
    reply: str
    used_context_ids: List[str]
    timings: dict

# -------------------------------------
# LOAD CHROMA CLIENT
# -------------------------------------
client = chromadb.PersistentClient(path=CHROMA_DIR)

COLLECTIONS = {
    "flood": "documents_flood",
    "cyclone": "documents_cyclone",
    "drought": "documents_drought",
    "general": "documents_general"
}

# -------------------------------------
# LOAD MODEL
# -------------------------------------
llm = None
if HAVE_LLAMA:
    llm = Llama(
        model_path=MODEL_PATH,
        n_ctx=2048,
        n_threads=4,
        n_gpu_layers=0,
        verbose=False
    )

# -------------------------------------
# HELPERS
# -------------------------------------
def detect_disaster(msg: str):
    m = msg.lower()
    if "flood" in m: return "flood"
    if "cyclone" in m or "hurricane" in m: return "cyclone"
    if "drought" in m or "water scarcity" in m: return "drought"
    return "general"

def get_collection(name: str):
    return client.get_collection(name)

def retrieve(query):
    disaster = detect_disaster(query)
    coll_name = COLLECTIONS[disaster]
    collection = get_collection(coll_name)

    res = collection.query(
        query_texts=[query],
        n_results=TOP_K,
        include=["documents", "metadatas"]
    )

    ids = []
    docs = []

    if "ids" in res:
        for sub in res["ids"]:
            if isinstance(sub, list):
                ids += [str(x) for x in sub]
            else:
                ids.append(str(sub))

    if "documents" in res:
        for sub in res["documents"]:
            if isinstance(sub, list):
                docs += sub
            else:
                docs.append(sub)

    return disaster, ids, docs

def build_prompt(query, docs):
    docs_text = "\n\n".join([f"[INFO]\n{d[:300]}" for d in docs[:3]])

    prompt = f"""
{SYSTEM_PROMPT}

{docs_text}

USER QUESTION: {query}

INSTRUCTIONS:
- Give a short numbered list (max 8 items)
- Each item 6–15 words
- India-specific if possible
- Prioritize most urgent safety steps first
- No citations, no references

ANSWER:
"""
    return prompt[-MAX_CONTEXT_CHARS:]

# -------------------------------------
# ROUTES
# -------------------------------------
@app.post("/chat", response_model=ChatResponse)
def chat(req: ChatRequest):

    t0 = time.time()

    disaster, ids_used, docs = retrieve(req.message)
    prompt = build_prompt(req.message, docs)

    t1 = time.time()
    out = llm(prompt, max_tokens=MAX_TOKENS, temperature=0.2)
    t2 = time.time()

    reply = out["choices"][0]["text"].strip()

    return ChatResponse(
        reply=reply,
        used_context_ids=ids_used,
        timings={
            "retrieve": t1 - t0,
            "generate": t2 - t1,
            "total": time.time() - t0
        }
    )

@app.get("/health")
def health():
    return {"status": "ok", "model_loaded": llm is not None}

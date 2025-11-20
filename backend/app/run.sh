#!/usr/bin/env bash
set -e
# run.sh - start the FastAPI server for GeoSafe

# activate venv if present (adjust path if your venv sits elsewhere)
if [ -f ../venv/bin/activate ]; then
  source ../venv/bin/activate
fi

export MODEL_PATH="../model/phi2/phi2-q4.gguf"
export CHROMA_DIR="../chroma_db"
export CHROMA_COLLECTION_NAME="documents"  # change if your collection has another name
export LLAMA_CPP_BIN="../llama.cpp/build/bin/llama-run"  # fallback binary
export RAG_TOP_K="5"
export MAX_GEN_TOKENS="256"

uvicorn main:app --host 0.0.0.0 --port 8000 --workers 1

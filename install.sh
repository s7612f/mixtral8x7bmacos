#!/bin/bash
set -e

# Install Ollama if missing
if ! command -v ollama >/dev/null 2>&1; then
  echo "Downloading Ollama..."
  curl -L https://ollama.ai/download/Ollama-darwin.zip -o /tmp/Ollama.zip
  unzip -q /tmp/Ollama.zip -d /Applications
fi

# Start Ollama service
open -a Ollama
sleep 5

# Pull Mixtral 8x7B model
ollama pull mixtral:8x7b

# Launch Web GUI
GUI_PATH="$(dirname "$0")/webgui/index.html"
open "$GUI_PATH"


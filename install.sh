#!/bin/bash
set -euo pipefail

error() {
  echo "Error: $1" >&2
  exit 1
}

# Install Ollama if missing
if ! command -v ollama >/dev/null 2>&1; then
  echo "Downloading Ollama..."
  curl -fsSL https://ollama.ai/download/Ollama-darwin.zip -o /tmp/Ollama.zip || error "Failed to download Ollama"
  unzip -q /tmp/Ollama.zip -d /Applications || error "Failed to unzip Ollama"
  rm -f /tmp/Ollama.zip
  if ! command -v ollama >/dev/null 2>&1; then
    error "Ollama installation failed"
  fi
fi

# Start Ollama service and wait for it to become available
echo "Starting Ollama service..."
open -a Ollama || error "Unable to launch Ollama"
timeout=60
until curl -s http://localhost:11434/api/tags >/dev/null 2>&1; do
  sleep 1
  timeout=$((timeout-1))
  if [ "$timeout" -le 0 ]; then
    error "Ollama service did not start"
  fi
done

# Pull Mixtral 8x7B model
echo "Downloading Mixtral 8x7B model..."
if ! ollama pull mixtral:8x7b; then
  error "Model download failed"
fi
if ! ollama list 2>/dev/null | grep -q '^mixtral:8x7b'; then
  error "Model not found after download"
fi

# Launch Web GUI
GUI_PATH="$(dirname "$0")/webgui/index.html"
if [ -f "$GUI_PATH" ]; then
  open "$GUI_PATH"
else
  echo "Web GUI not found at $GUI_PATH" >&2
fi


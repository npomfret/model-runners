#!/bin/bash
# Phi-3-mini-128K - Microsoft's lightweight long-context model
# Size: 3.8B parameters
# Speed: ~25-35 tokens/sec (very fast)
# Memory: ~2.5GB
# Context: 128K tokens (excellent for long documents)
# Best for: Fast inference, long context, document analysis
# Tool use: Good
# Port: 11449

# Load HuggingFace token if available
if [ -f .env ]; then
    export $(cat .env | grep HF_TOKEN)
fi

uv run python -m vllm_mlx.server \
  --model mlx-community/Phi-3-mini-128k-instruct-4bit \
  --host 0.0.0.0 \
  --port 11449

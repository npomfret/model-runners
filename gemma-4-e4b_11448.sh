#!/bin/bash
# Gemma-4-E4B - Google's latest efficient model
# Size: 8B parameters (effective)
# Speed: ~18-25 tokens/sec
# Memory: ~6GB
# Best for: Fast inference, instruction following
# Tool use: Good
# Port: 11448

# Load HuggingFace token if available
if [ -f .env ]; then
    export $(cat .env | grep HF_TOKEN)
fi

uv run python gemma4_vlm_server.py \
  --model mlx-community/gemma-4-e4b-it-8bit \
  --host 0.0.0.0 \
  --port 11448

#!/bin/bash
# DeepSeek-R1-Distill-Qwen-7B - Fast reasoning with tool use
# Size: 7B parameters
# Speed: ~15-20 tokens/sec
# Memory: ~4GB
# Best for: Reasoning + tool use, fast inference
# Tool use: Excellent
# Port: 11444

# Load HuggingFace token if available
if [ -f .env ]; then
    export $(cat .env | grep HF_TOKEN)
fi

uv run python -m vllm_mlx.server \
  --model mlx-community/DeepSeek-R1-Distill-Qwen-7B-4bit \
  --host 0.0.0.0 \
  --port 11444

#!/bin/bash
# Qwen3-32B-Instruct - Latest Qwen, strong reasoning and tool use
# Size: 32B parameters
# Speed: ~8-12 tokens/sec
# Memory: ~18GB
# Best for: State-of-the-art reasoning, code, tool use
# Tool use: Excellent - native support with strong reasoning
# Port: 11443

# Load HuggingFace token if available
if [ -f .env ]; then
    export $(cat .env | grep HF_TOKEN)
fi

uv run python -m vllm_mlx.server \
  --model mlx-community/Qwen3-32B-4bit \
  --host 0.0.0.0 \
  --port 11443

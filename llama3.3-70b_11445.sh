#!/bin/bash
# Llama 3.3 70B - Most powerful Llama, state-of-the-art general purpose
# Size: 70B parameters
# Speed: ~4-7 tokens/sec
# Memory: ~40GB (4-bit) - may exceed 20GB, watch memory
# Best for: Maximum capability, complex reasoning, expert level responses
# Tool use: Excellent - native function calling support
# Port: 11445
# WARNING: May need 20GB+ memory, monitor during inference

# Load HuggingFace token if available
if [ -f .env ]; then
    export $(cat .env | grep HF_TOKEN)
fi

uv run python -m vllm_mlx.server \
  --model mlx-community/Llama-3.3-70B-Instruct-4bit \
  --host 0.0.0.0 \
  --port 11445

#!/bin/bash
# Qwen3-VL-30B - Vision Language Model, multimodal SOTA
# Size: 30B parameters (multimodal, A3B quantization)
# Speed: ~6-10 tokens/sec (text output)
# Memory: ~18GB
# Best for: Image understanding, visual reasoning, document analysis
# Tool use: Excellent - combines vision understanding with tool calling
# Port: 11447

# Load HuggingFace token if available
if [ -f .env ]; then
    export $(cat .env | grep HF_TOKEN)
fi

uv run python -m vllm_mlx.server \
  --model mlx-community/Qwen3-VL-30B-A3B-Instruct-4bit \
  --mllm \
  --host 0.0.0.0 \
  --port 11447

#!/bin/bash
# Gemma-4-31B - dense flagship, full 31B active params per token
# Size: 31B parameters, 8-bit quantization
# Memory: ~35-40GB
# Speed: slower than E4B/26B MoE, but substantially more capable
# Best for: use cases where E4B capacity is insufficient
# Port: 11452
# Note: uses mlx-vlm (vllm_mlx does not yet support gemma4)

if [ -f .env ]; then
    export $(cat .env | grep HF_TOKEN)
fi

uv run python -m mlx_vlm server \
  --model mlx-community/gemma-4-31b-it-8bit \
  --host 0.0.0.0 \
  --port 11452

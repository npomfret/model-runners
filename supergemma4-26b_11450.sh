#!/bin/bash
# SuperGemma4-26B Abliterated Multimodal - Gemma-4-26B-A4B fine-tune, uncensored VLM
# Size: 26B parameters (multimodal, 4bit quantization)
# Memory: ~15GB
# Best for: Vision + language, uncensored responses, document/image understanding
# Port: 11450

# Load HuggingFace token if available
if [ -f .env ]; then
    export $(cat .env | grep HF_TOKEN)
fi

uv run python -m vllm_mlx.server \
  --model Jiunsong/supergemma4-26b-abliterated-multimodal-mlx-4bit \
  --mllm \
  --host 0.0.0.0 \
  --port 11450

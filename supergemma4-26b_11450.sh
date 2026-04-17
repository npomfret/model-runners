#!/bin/bash
# SuperGemma4-26B Abliterated Multimodal - Gemma-4-26B-A4B fine-tune, uncensored VLM
# Size: 26B parameters (multimodal, 4bit quantization)
# Memory: ~15GB
# Best for: Vision + language, uncensored responses, document/image understanding
# Port: 11450

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server Jiunsong/supergemma4-26b-abliterated-multimodal-mlx-4bit 11450 --mllm

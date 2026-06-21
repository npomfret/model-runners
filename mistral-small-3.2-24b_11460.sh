#!/bin/bash
# Mistral-Small-3.2-24B-Instruct - dense instruct model (non-reasoning)
# Size: 24B parameters, 8-bit quantization
# Memory: ~25GB on disk (comfortable in 64GB; plenty of KV-cache headroom)
# Best for: fast everyday chat, clean structured output / JSON, tool calling
# Tool use: Excellent - clean function-calling format, no <think> overhead
# Port: 11460
# Note: plain instruct model - no reasoning parser or tool-call parser flags needed.

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Mistral-Small-3.2-24B-Instruct-2506-8bit 11460

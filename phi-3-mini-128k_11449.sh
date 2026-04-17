#!/bin/bash
# Phi-3-mini-128K - Microsoft's lightweight long-context model
# Size: 3.8B parameters
# Speed: ~25-35 tokens/sec (very fast)
# Memory: ~2.5GB
# Context: 128K tokens (excellent for long documents)
# Best for: Fast inference, long context, document analysis
# Tool use: Good
# Port: 11449

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Phi-3-mini-128k-instruct-4bit 11449

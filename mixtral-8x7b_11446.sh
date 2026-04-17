#!/bin/bash
# Mixtral 8x7B - Powerful MoE model, expert routing
# Size: 7B active (46B total with MoE)
# Speed: ~8-12 tokens/sec
# Memory: ~18GB
# Best for: Specialized task routing, expert selection, efficient reasoning
# Tool use: Excellent - MoE allows different experts for different tools
# Port: 11446

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Mixtral-8x7B-Instruct-v0.1-hf-4bit-mlx 11446

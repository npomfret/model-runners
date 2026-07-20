#!/bin/bash
# Qwen3.6-27B (OptiQ 4-bit) - dense model, thinking mode, tool use
# Size: 27B parameters, OptiQ 4-bit quantization
# Memory: ~20GB on disk (comfortable in 64GB)
# Best for: higher single-token quality than the 35B-A3B MoE on code; dense = slower/token
# Tool use: Hermes-style
# Port: 11462
# Note: reasoning model - <think>…</think>, so use the qwen3 reasoning parser.

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3.6-27B-OptiQ-4bit 11462 --reasoning-parser qwen3

#!/bin/bash
# Qwen3.6-35B-A3B (OptiQ 4-bit) - Sparse MoE (35B total / ~3B active), thinking, tool use
# Size: 35B total (~3B active), OptiQ 4-bit quantization
# Memory: ~25GB on disk (comfortable in 64GB)
# Best for: fast agentic/tool-calling; MoE keeps per-token cost low
# Tool use: Hermes-style
# Port: 11463
# Note: reasoning model - <think>…</think>, so use the qwen3 reasoning parser.
# Compare vs the nvfp4 (11455, ~19GB) and 8bit (11457, ~38GB) quants of the same model.

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3.6-35B-A3B-OptiQ-4bit 11463 --reasoning-parser qwen3

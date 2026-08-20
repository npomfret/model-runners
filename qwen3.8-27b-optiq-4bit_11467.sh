#!/bin/bash
# Qwen3.8-27B (OptiQ 4-bit) - dense native-multimodal (VL) model, thinking, tools
# Size: 27B parameters, OptiQ calibrated 4-bit quantization
# Memory: ~16GB on disk (much more headroom than the 8-bit's ~30GB)
# Context: 262K native (extensible to 1M via YaRN)
# Best for: the FAST way to run Qwen3.8-27B on this box - measured 17.3-18.3
#           tok/s vs 9.2 for the 8-bit (2026-08-20, 400-tok completion, temp 0,
#           model running alone). Use qwen3.8-27b_11464.sh (8-bit) when
#           maximum quality matters more than speed.
# Tool use: Hermes-style
# Port: 11467
# Note: thinking on by default - <think>…</think>, so use the qwen3 reasoning
#       parser. MTP/speculative decoding was tested (vllm_mlx and mlx-vlm
#       0.6.15 + mlx-community MTP drafts) and does NOT help this arch on
#       current stock kernels - see qwen3.8-27b-mtp_11465.sh header.

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3.8-27B-OptiQ-4bit 11467 --reasoning-parser qwen3

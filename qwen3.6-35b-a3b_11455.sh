#!/bin/bash
# Qwen 3.6 35B-A3B (nvfp4) - latest Qwen, MoE with ~3B active params
# Size: 35B total (~3B active), nvfp4 microscaling quantization
# Memory: ~19GB
# Speed: fast per-token thanks to MoE + MLX-native FP4 kernels
# Best for: strong reasoning + tool use with Gemma-MoE-class latency
# Port: 11455

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3.6-35B-A3B-nvfp4 11455 --reasoning-parser qwen3

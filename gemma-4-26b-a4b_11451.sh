#!/bin/bash
# Gemma-4-26B-A4B - MoE variant, 3.8B active params per token
# Size: 26B total (~3.8B active), 8-bit quantization
# Memory: ~28GB
# Speed: fast per-token thanks to MoE routing
# Best for: strong quality at E4B-class latency
# Port: 11451
# Note: uses mlx-vlm (vllm_mlx does not yet support gemma4)

exec "$(dirname "$0")/_launch.sh" "mlx_vlm server" mlx-community/gemma-4-26b-a4b-it-8bit 11451

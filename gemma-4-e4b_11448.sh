#!/bin/bash
# Gemma-4-E4B - Google's latest efficient model
# Size: 8B parameters (effective)
# Speed: ~18-25 tokens/sec
# Memory: ~6GB
# Best for: Fast inference, instruction following
# Tool use: Good
# Port: 11448

exec "$(dirname "$0")/_launch.sh" "mlx_vlm server" mlx-community/gemma-4-e4b-it-8bit 11448

#!/bin/bash
# DeepSeek-R1-Distill-Qwen-7B - Fast reasoning with tool use
# Size: 7B parameters
# Speed: ~15-20 tokens/sec
# Memory: ~4GB
# Best for: Reasoning + tool use, fast inference
# Tool use: Excellent
# Port: 11444

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/DeepSeek-R1-Distill-Qwen-7B-4bit 11444

#!/bin/bash
# Qwen3-32B-Instruct - Latest Qwen, strong reasoning and tool use
# Size: 32B parameters
# Speed: ~8-12 tokens/sec
# Memory: ~18GB
# Best for: State-of-the-art reasoning, code, tool use
# Tool use: Excellent - native support with strong reasoning
# Port: 11443

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3-32B-4bit 11443

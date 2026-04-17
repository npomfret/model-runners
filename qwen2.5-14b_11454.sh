#!/bin/bash
# Qwen2.5-14B-Instruct - mid-size Qwen 2.5, strong reasoning and tool use
# Size: 14B parameters, 4-bit quantization
# Memory: ~8GB
# Best for: capable reasoning/code/tool use with headroom on 32GB systems
# Tool use: native support
# Port: 11454

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen2.5-14B-Instruct-4bit 11454

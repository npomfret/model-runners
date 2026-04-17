#!/bin/bash
# Llama 3.3 70B - Most powerful Llama, state-of-the-art general purpose
# Size: 70B parameters
# Speed: ~4-7 tokens/sec
# Memory: ~40GB (4-bit) - may exceed 20GB, watch memory
# Best for: Maximum capability, complex reasoning, expert level responses
# Tool use: Excellent - native function calling support
# Port: 11445
# WARNING: May need 20GB+ memory, monitor during inference

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Llama-3.3-70B-Instruct-4bit 11445

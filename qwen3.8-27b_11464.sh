#!/bin/bash
# Qwen3.8-27B - dense native-multimodal (VL) model, thinking mode, tool use
# Size: 27B parameters, 8-bit quantization
# Memory: ~30GB
# Context: 262K native (extensible to 1M via YaRN)
# Best for: coding, office/professional workflows, long-horizon agentic tasks;
#           outperforms Qwen3.7-Plus overall per Qwen (released 2026-08-14)
# Tool use: Hermes-style
# Port: 11464
# Note: same qwen3_5 architecture as Qwen3.5-27B, so vllm_mlx support matches.
#       Thinking on by default - <think>…</think>, so use the qwen3 reasoning parser.

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3.8-27B-8bit 11464 --reasoning-parser qwen3

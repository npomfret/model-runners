#!/bin/bash
# Qwen3.5-27B - Gated Delta + sparse MoE, thinking mode, tool use
# Size: 27B parameters, 8-bit quantization
# Memory: ~30GB
# Context: 262K native (extensible to 1M via YaRN)
# Best for: agentic/tool-calling workloads, long context
# Tool use: Excellent - Hermes-style recommended
# Port: 11455
# Note: novel architecture; vllm_mlx may reject if arch unsupported

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3.5-27B-8bit 11455

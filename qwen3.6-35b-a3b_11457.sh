#!/bin/bash
# Qwen3.6-35B-A3B - Sparse MoE (35B total / ~3B active), thinking mode, tool use
# Size: 35B parameters, 8-bit quantization
# Memory: ~38GB
# Best for: agentic/tool-calling workloads with low active-param cost
# Tool use: Excellent - Hermes-style recommended
# Port: 11457
# Note: MoE architecture; vllm_mlx may reject if arch unsupported.
# See also qwen3.6-35b-a3b_11455.sh for the smaller nvfp4 variant of the same model.

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3.6-35B-A3B-8bit 11457

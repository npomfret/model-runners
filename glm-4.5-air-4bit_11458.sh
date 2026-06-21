#!/bin/bash
# GLM-4.5-Air - Sparse MoE (106B total / ~12B active), thinking mode, tool use
# Size: 106B parameters, 4-bit quantization
# Memory: ~60GB on disk (only fits 64GB budget at 4-bit; little KV-cache headroom)
# Best for: strong all-round reasoning/coding/agentic; the well-regarded "Air" model
# Tool use: Excellent
# Port: 11458
# Note: 6-bit (~87GB) and 8-bit (~114GB) exceed a 64GB budget; 4-bit is the only fit.

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/GLM-4.5-Air-4bit 11458

#!/bin/bash
# GLM-4.5-Air - Sparse MoE (106B total / ~12B active), thinking mode, tool use
# Size: 106B parameters, 4-bit quantization
# Memory: ~60GB on disk (only fits 64GB budget at 4-bit; little KV-cache headroom)
# Best for: strong all-round reasoning/coding/agentic; the well-regarded "Air" model
# Tool use: Excellent - same GLM format as Flash, parsed by the glm47 tool parser
# Port: 11458
# Note: 6-bit (~87GB) and 8-bit (~114GB) exceed a 64GB budget; 4-bit is the only fit.
#
# Same plumbing as glm-4.7-flash_11459.sh: GLM tool calling needs
# --enable-auto-tool-choice --tool-call-parser glm47, only exposed by the cli
# `serve` entrypoint (not vllm_mlx.server / _launch.sh). Reasoning uses <think>…</think>
# like Qwen3, so reuse the qwen3 reasoning parser.
#
# REQUIRES local patch to vllm_mlx api/utils.py: SPECIAL_TOKENS_PATTERN must NOT
# strip </?tool_call>, or the engine eats GLM's tool-call delimiters before the
# glm47 parser runs and tool calling silently fails. A `uv sync`/reinstall reverts
# it — re-apply (backup at api/utils.py.orig). Chat works without the patch.
set -e

cd "$(dirname "$0")"

if [ -f .env ]; then
    export $(grep HF_TOKEN .env)
fi

exec uv run python -m vllm_mlx.cli serve mlx-community/GLM-4.5-Air-4bit \
  --host 0.0.0.0 \
  --port 11458 \
  --reasoning-parser qwen3 \
  --enable-auto-tool-choice --tool-call-parser glm47

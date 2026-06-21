#!/bin/bash
# GLM-4.7-Flash - Sparse MoE (~30B total / ~3B active), thinking mode, tool use
# Size: ~30B parameters, 8-bit quantization
# Memory: ~32GB on disk (comfortable in 64GB; plenty of KV-cache headroom)
# Best for: coding/agentic workloads; newest GLM (Jan 2026), full 8-bit quality
# Tool use: Excellent - needs the dedicated glm47 tool-call parser
# Port: 11459
# Note: 4-bit (~17GB) and 6-bit (~24GB) variants exist if more headroom is needed.
#
# Unlike the other scripts this does NOT use _launch.sh: GLM tool calling requires
# --enable-auto-tool-choice --tool-call-parser glm47, which only the cli `serve`
# entrypoint exposes (vllm_mlx.server lacks the tool-parser flags). cli `serve`
# takes the model positionally, so the shared launcher's --model form won't work.
# Reasoning: GLM-4.7 emits <think>…</think> like Qwen3; reuse the qwen3 reasoning
# parser (no GLM-specific one exists).
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

exec uv run python -m vllm_mlx.cli serve mlx-community/GLM-4.7-Flash-8bit \
  --host 0.0.0.0 \
  --port 11459 \
  --reasoning-parser qwen3 \
  --enable-auto-tool-choice --tool-call-parser glm47

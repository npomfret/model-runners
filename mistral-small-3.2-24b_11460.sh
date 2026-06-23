#!/bin/bash
# Mistral-Small-3.2-24B-Instruct - dense instruct model (non-reasoning)
# Size: 24B parameters, 8-bit quantization
# Memory: ~24GB on disk (comfortable in 64GB; plenty of KV-cache headroom)
# Best for: fast everyday chat, writing, structured text - NO <think> overhead
# Port: 11460
#
# CHAT-ONLY: tool calling does NOT work here. The MLX repos ship a chat-only Jinja
#   template that silently drops `tools` (Mistral's real tool format uses
#   mistral_common/Tekken, not Jinja), so the model never sees tool defs and never
#   emits a call - even with tool_choice=required. vllm_mlx has no --chat-template
#   flag to override it. Use GLM-4.7-Flash (11459) or the Qwen servers when you
#   need tools. test-server.sh step [3/3] will fail for this model - expected.
#
# Repo: use lmstudio-community, NOT mlx-community - the mlx-community 8bit conversion
#   ships NO chat template at all, so vllm_mlx's chat endpoint 500s. lmstudio's
#   template at least handles chat correctly.

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server lmstudio-community/Mistral-Small-3.2-24B-Instruct-2506-MLX-8bit 11460

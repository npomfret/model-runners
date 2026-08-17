#!/bin/bash
# Qwen3.8-27B + MTP speculative decoding - dense native-multimodal, thinking, tools
# Size: 27B parameters, 8-bit quantization (+849MB BF16 MTP head)
# Memory: ~31GB
# Context: 262K native (extensible to 1M via YaRN)
# Best for: EXPERIMENTAL - currently SLOWER than qwen3.8-27b_11464.sh.
#           Measured 2026-08-16 (400-tok completion, temp 0): simple engine
#           9.2 tok/s, continuous-batching 4.4, CB+MTP 3.9. MTP only exists in
#           the CB engine, whose single-stream overhead exceeds the MTP gain
#           (and it's capped at 1 draft token, still true in vllm-mlx 0.4.1).
#           Kept for when vllm-mlx lands a faster MTP path - use 11464 for now.
# Tool use: Hermes-style
# Port: 11465
#
# Unlike most scripts this does NOT use _launch.sh: --enable-mtp is only exposed
# by the cli `serve` entrypoint (vllm_mlx.server lacks the MTP flags), and cli
# `serve` takes the model positionally.
#
# --continuous-batching is REQUIRED: without it the simple engine forwards
# mtp=True to stock mlx_lm's generate_step, which doesn't accept it (500s on
# some requests). The batched scheduler has its own MTP draft/verify logic.
#
# REQUIRES MTP weights in the HF cache snapshot (mtp/weights.safetensors +
# num_nextn_predict_layers in config.json). They are NOT part of the
# mlx-community quant - they were extracted from Qwen/Qwen3.8-27B with
# vllm-mlx's scripts/add_mtp_weights_qwen35.py (run 2026-08-16). If the model
# is re-downloaded/cache cleared, re-run that script or MTP silently won't
# install (server still works, just slow).
set -e

cd "$(dirname "$0")"

if [ -f .env ]; then
    export $(grep HF_TOKEN .env)
fi

exec uv run python -m vllm_mlx.cli serve mlx-community/Qwen3.8-27B-8bit \
  --host 0.0.0.0 \
  --port 11465 \
  --reasoning-parser qwen3 \
  --continuous-batching \
  --enable-mtp \
  --timeout 900

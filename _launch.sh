#!/bin/bash
# Shared launcher used by every <model>_<port>.sh script.
# Usage: _launch.sh "<python -m args>" <model-id> <port> [extra flags...]
set -e

ENGINE=$1
MODEL=$2
PORT=$3
shift 3

# vllm_mlx defaults to a 300s deadline on non-streaming requests, which slow
# or thinking-heavy models can exceed. Raise it to 15 min. (mlx_vlm server
# has no --timeout flag, so only apply to vllm_mlx.)
if [ "$ENGINE" = "vllm_mlx.server" ]; then
    set -- "$@" --timeout 900
fi

cd "$(dirname "$0")"

if [ -f .env ]; then
    export $(grep HF_TOKEN .env)
fi

exec uv run python -m $ENGINE \
  --model "$MODEL" \
  --host 0.0.0.0 \
  --port "$PORT" \
  "$@"

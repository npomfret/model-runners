#!/bin/bash
# Shared launcher used by every <model>_<port>.sh script.
# Usage: _launch.sh "<python -m args>" <model-id> <port> [extra flags...]
set -e

ENGINE=$1
MODEL=$2
PORT=$3
shift 3

cd "$(dirname "$0")"

if [ -f .env ]; then
    export $(grep HF_TOKEN .env)
fi

exec uv run python -m $ENGINE \
  --model "$MODEL" \
  --host 0.0.0.0 \
  --port "$PORT" \
  "$@"

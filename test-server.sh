#!/bin/bash
# Smoke-test an MLX LLM server: /v1/models, basic chat, and tool calling.
# Usage: ./test-server.sh <port> [model_id]
#   Port is required. If model_id is omitted we pick the first entry from
#   /v1/models, which is fine for single-model backends (vllm_mlx) but
#   unreliable for mlx_vlm (lists the full HF cache) — pass it explicitly
#   to be sure.
set -eu

PORT=${1:-}
MODEL=${2:-auto}

if [ -z "$PORT" ]; then
    echo "Usage: $0 <port> [model_id]" >&2
    exit 2
fi

BASE="http://localhost:$PORT"

# 1. Connection
echo "[1/3] /v1/models"
if ! timeout 5 curl -sSf "$BASE/v1/models" > /tmp/test-server-models.json; then
    echo "  ❌ Server not responding on port $PORT"
    exit 1
fi
MODELS=$(jq -r '.data[].id' < /tmp/test-server-models.json)
echo "  available:"
echo "$MODELS" | sed 's/^/    /'

if [ "$MODEL" = "auto" ]; then
    MODEL=$(echo "$MODELS" | head -1)
    echo "  using (auto): $MODEL"
fi

# 2. Basic chat
echo "[2/3] chat completion"
RESP=$(timeout 60 curl -sSf "$BASE/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$MODEL\",
    \"messages\": [{\"role\": \"user\", \"content\": \"Say hello in one short sentence.\"}],
    \"max_tokens\": 50
  }")

CONTENT=$(echo "$RESP" | jq -r '.choices[0].message.content // empty')
if [ -z "$CONTENT" ]; then
    echo "  ❌ empty content"
    echo "$RESP" | jq . >&2 || echo "$RESP" >&2
    exit 1
fi
echo "  ✓ \"$CONTENT\""

# 3. Tool calling — require a non-empty tool_calls array, not just presence.
echo "[3/3] tool call"
RESP=$(timeout 60 curl -sSf "$BASE/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$MODEL\",
    \"messages\": [{\"role\": \"user\", \"content\": \"What is the weather in San Francisco?\"}],
    \"tools\": [{
      \"type\": \"function\",
      \"function\": {
        \"name\": \"get_weather\",
        \"description\": \"Get the current weather for a location.\",
        \"parameters\": {
          \"type\": \"object\",
          \"properties\": {
            \"location\": {\"type\": \"string\", \"description\": \"City and state, e.g. San Francisco, CA\"},
            \"unit\": {\"type\": \"string\", \"enum\": [\"celsius\", \"fahrenheit\"]}
          },
          \"required\": [\"location\"]
        }
      }
    }],
    \"tool_choice\": \"auto\",
    \"max_tokens\": 1024
  }")

CALLS=$(echo "$RESP" | jq '.choices[0].message.tool_calls // [] | length')
if [ "$CALLS" -lt 1 ]; then
    CONTENT=$(echo "$RESP" | jq -r '.choices[0].message.content // empty')
    echo "  ❌ no tool call emitted"
    echo "  finish_reason: $(echo "$RESP" | jq -r '.choices[0].finish_reason')"
    echo "  content: $CONTENT"
    exit 1
fi

NAME=$(echo "$RESP" | jq -r '.choices[0].message.tool_calls[0].function.name')
ARGS=$(echo "$RESP" | jq -r '.choices[0].message.tool_calls[0].function.arguments')
echo "  ✓ $NAME($ARGS)"

echo "[OK] all checks passed"

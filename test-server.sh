#!/bin/bash
# Test script for MLX LLM servers
# Usage: ./test-server.sh <port> [model_name]
# Example: ./test-server.sh 11437
# Example: ./test-server.sh 11437 "mlx-community/Mistral-7B-Instruct-v0.3-4bit"

PORT=${1:-11437}
MODEL=${2:-"auto"}

if [ "$PORT" -eq 0 ] 2>/dev/null; then
    echo "Usage: $0 <port> [model_name]"
    echo "Example: $0 11437"
    echo "Example: $0 11437 'mlx-community/Mistral-7B-Instruct-v0.3-4bit'"
    exit 1
fi

echo "Testing server on port $PORT..."
echo ""

# Check connection
echo "1. Testing connection..."
if ! timeout 2 curl -s http://localhost:$PORT/v1/models > /dev/null 2>&1; then
    echo "❌ Server not responding on port $PORT"
    exit 1
fi
echo "✓ Server responding"
echo ""

# Get available models
echo "2. Available models:"
MODELS=$(curl -s http://localhost:$PORT/v1/models | jq -r '.data[].id')
echo "$MODELS" | head -5
echo ""

# Use first model if not specified
if [ "$MODEL" = "auto" ]; then
    MODEL=$(echo "$MODELS" | head -1)
    echo "Using model: $MODEL"
    echo ""
fi

# Test inference
echo "3. Testing inference..."
RESPONSE=$(timeout 20 curl -s http://localhost:$PORT/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "'"${MODEL}"'",
    "messages": [{"role": "user", "content": "Say hello in one sentence"}],
    "max_tokens": 20
  }')

CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null)

if [ -z "$CONTENT" ] || [ "$CONTENT" = "null" ]; then
    echo "❌ Inference failed or returned empty"
    echo "Response: $RESPONSE" | head -5
    exit 1
fi

echo "✓ Inference working"
echo ""
echo "Response:"
echo "  \"$CONTENT\""

#!/bin/bash
# Test tool use / function calling capability across models
# Usage: ./test-tool-use.sh <port> [model_id]
# Example: ./test-tool-use.sh 11441

PORT=${1:-11441}
MODEL=${2:-"auto"}

echo "Testing tool use capability on port $PORT..."
echo ""

# Check connection
if ! timeout 2 curl -s http://localhost:$PORT/v1/models > /dev/null 2>&1; then
    echo "❌ Server not responding on port $PORT"
    exit 1
fi

echo "✓ Server responding"
echo ""

# Test basic tool calling
echo "Testing function calling with weather tool..."
echo ""

RESPONSE=$(timeout 20 curl -s http://localhost:$PORT/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "'"${MODEL}"'",
    "messages": [{"role": "user", "content": "What is the weather in San Francisco?"}],
    "tools": [
      {
        "type": "function",
        "function": {
          "name": "get_weather",
          "description": "Get the current weather for a location",
          "parameters": {
            "type": "object",
            "properties": {
              "location": {
                "type": "string",
                "description": "The city and state, e.g. San Francisco, CA"
              },
              "unit": {
                "type": "string",
                "enum": ["celsius", "fahrenheit"],
                "description": "Temperature unit"
              }
            },
            "required": ["location"]
          }
        }
      }
    ],
    "max_tokens": 200
  }')

echo "Response:"
echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
echo ""

# Check for tool use
if echo "$RESPONSE" | jq -e '.choices[0].message.tool_calls' > /dev/null 2>&1; then
    echo "✓ Model called a tool!"
    echo "$RESPONSE" | jq '.choices[0].message.tool_calls'
elif echo "$RESPONSE" | jq -e '.choices[0].message.content' > /dev/null 2>&1; then
    echo "⚠ Model generated text (no tool call)"
    CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')
    echo "Response: $CONTENT"
else
    echo "❌ Failed to get response"
    exit 1
fi

echo ""
echo "Tool use test complete."

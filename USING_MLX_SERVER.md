# Using the MLX LLM Server

A local OpenAI-compatible LLM server running on Apple Silicon. No API key, runs on `localhost`.

## 1. Start a model

In the `mlx-server` repo, run one of the `<model>_<port>.sh` scripts. The port is in the filename:

```bash
./qwen3.6-35b-a3b_11456.sh   # serves on http://localhost:11456
```

Leave it running. First start downloads the model (can take a while).

## 2. Check it's up

```bash
curl -s http://localhost:11456/v1/models | jq -r '.data[].id'
```

The id it prints is the value you pass as `"model"` below.

## 3. Call it (OpenAI-compatible)

Base URL: `http://localhost:11456/v1` — endpoints `/chat/completions`, `/models`. Any dummy API key works.

```bash
curl -s http://localhost:11456/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Qwen3.6-35B-A3B-8bit",
    "messages": [{"role": "user", "content": "Hello in one sentence"}],
    "max_tokens": 100
  }'
```

OpenAI SDK example:

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:11456/v1", api_key="not-needed")
resp = client.chat.completions.create(
    model="mlx-community/Qwen3.6-35B-A3B-8bit",
    messages=[{"role": "user", "content": "Hello"}],
)
print(resp.choices[0].message.content)
```

Streaming (`"stream": true`) and tool/function calling are supported.

## Notes

- One model per port. Available models = the `*_<port>.sh` scripts in this repo.
- It's local-only inference: slower than hosted APIs, no rate limits, nothing leaves the machine.
- If a call fails, confirm the script is still running and step 2 responds.

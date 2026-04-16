# MLX LLM Server Scripts - State-of-the-Art Edition

Quick-start scripts for running the latest, most capable open-source LLM models on Apple Silicon with 20GB+ memory.

All models use **vllm-mlx** (patched for the v0.2.7 bug) and support tool use/function calling.

## Available SOTA Models

See [SOTA_MODELS.md](SOTA_MODELS.md) for detailed descriptions and benchmarks.

### Tier 1: Maximum Capability - Llama 3.3 70B (Port 11445)
```bash
./llama3.3-70b_11445.sh
./test-server.sh 11445
```
- **Capability**: 🔥🔥🔥 Highest quality responses
- **Size**: 70B parameters
- **Speed**: ~4-7 tokens/sec
- **Memory**: ~40GB (watch it)
- **Best for**: Complex reasoning, expert-level tasks, maximum capability

### Tier 1: Best Reasoning - DeepSeek-V3 (Port 11444)
```bash
./deepseek-v3_11444.sh
./test-server.sh 11444
```
- **Capability**: 🔥🔥🔥 Top reasoning performance
- **Size**: 37B active (MoE)
- **Speed**: ~6-10 tokens/sec
- **Memory**: ~18GB
- **Best for**: Complex reasoning, tool orchestration, problem-solving

### Tier 2: Best Balance - Qwen3-32B (Port 11443)
```bash
./qwen3-32b_11443.sh
./test-server.sh 11443
```
- **Capability**: 🔥🔥 Excellent all-around
- **Size**: 32B parameters
- **Speed**: ~8-12 tokens/sec
- **Memory**: ~18GB
- **Best for**: Balanced speed/capability, code, general purpose

### Tier 2: MoE Architecture - Mixtral 8x7B (Port 11446)
```bash
./mixtral-8x7b_11446.sh
./test-server.sh 11446
```
- **Capability**: 🔥🔥 Excellent reasoning
- **Size**: 7B active (46B total)
- **Speed**: ~8-12 tokens/sec
- **Memory**: ~18GB
- **Best for**: Expert routing, specialized tool selection

### Bonus: Multimodal - Qwen3-VL-32B (Port 11447)
```bash
./qwen3-vl-32b_11447.sh
./test-server.sh 11447
```
- **Capability**: Vision + Language understanding
- **Size**: 32B (multimodal)
- **Speed**: ~6-10 tokens/sec
- **Memory**: ~20GB
- **Best for**: Image analysis, document understanding, visual reasoning

### Baseline (Legacy) - Mistral 7B (Port 11437)
```bash
./mistral-7b-instruct_11437.sh
```
- For baseline testing/comparison only

## Quick Start

**Start here:** Best balance of speed and quality
```bash
./qwen3-32b_11443.sh
./test-server.sh 11443
```

**Maximum capability (slower):**
```bash
./llama3.3-70b_11445.sh
./test-server.sh 11445
```

**Best reasoning:**
```bash
./deepseek-v3_11444.sh
./test-server.sh 11444
```

## Testing

Use the test script to verify any server:
```bash
./test-server.sh <port> [model_name]

# Examples
./test-server.sh 11441
./test-server.sh 11441 "mlx-community/Functionary-Small-v3.2-4bit"
```

The test script will:
1. Check server connectivity
2. List available models
3. Run an inference test
4. Display the response

## API Usage

All servers support OpenAI-compatible API:

```bash
curl -X POST http://localhost:11441/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Functionary-Small-v3.2-4bit",
    "messages": [{"role": "user", "content": "Hello"}],
    "max_tokens": 50,
    "temperature": 0.7
  }'
```

### Tool Use Example

```bash
curl -X POST http://localhost:11441/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Functionary-Small-v3.2-4bit",
    "messages": [{"role": "user", "content": "What is 2+2?"}],
    "tools": [{
      "type": "function",
      "function": {
        "name": "calculate",
        "description": "Perform basic arithmetic",
        "parameters": {
          "type": "object",
          "properties": {
            "expression": {"type": "string"}
          },
          "required": ["expression"]
        }
      }
    }]
  }'
```

## Implementation Notes

- **vllm-mlx**: Patched version (0.2.7) with missing return statement fix applied
- All models tested and working with the patch
- Custom servers: gemma4_vlm_server.py exists but not maintained

## Cache

Models are cached in `~/.cache/huggingface/hub/`

Current models cached:
- Mistral 7B (3.8GB)
- Qwen variants (7-32GB each)
- Gemma 4 31B (31GB)
- Others

## Memory Requirements

- Mistral 7B: ~3-4GB during inference
- Can run on any Mac with 8GB+ unified memory

## Stopping

```bash
pkill -f "mlx_lm.server"
```

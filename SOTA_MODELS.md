# State-of-the-Art LLM Models for MLX Server

Guide to running the latest, most capable open-source models on Apple Silicon with 20GB+ memory.

## Quick Start - Best of Each Category

### Most Capable General Purpose
**→ Llama 3.3 70B (port 11445)**
```bash
./llama3.3-70b_11445.sh
./test-server.sh 11445
```
- Largest and most capable (70B)
- Best for complex multi-step tasks
- ⚠️ Pushes 20GB limit on 4-bit - monitor memory

### Best Reasoning + Tool Use
**→ DeepSeek-V3 (port 11444)**
```bash
./deepseek-v3_11444.sh
./test-server.sh 11444
```
- State-of-the-art reasoning (top of leaderboards)
- Mixture of Experts (MoE) - 37B active
- Excellent at complex tool orchestration

### Best All-Around Balance
**→ Qwen3-32B (port 11443)**
```bash
./qwen3-32b_11443.sh
./test-server.sh 11443
```
- Latest Qwen 3 architecture
- 32B of pure capability
- Best balance of speed and quality
- Excellent code and reasoning

### Best Multimodal
**→ Qwen3-VL-32B (port 11447)**
```bash
./qwen3-vl-32b_11447.sh
./test-server.sh 11447
```
- Vision + Language understanding
- Excellent for image analysis
- Can use tools based on visual input

### Best MoE Architecture
**→ Mixtral 8x7B (port 11446)**
```bash
./mixtral-8x7b_11446.sh
./test-server.sh 11446
```
- Mixture of Experts routing
- 7B active, 46B total
- Different experts for different task types

## Performance Comparison

| Model | Port | Size (Active) | Memory | Speed | Reasoning | Tools | Use Case |
|-------|------|---------------|--------|-------|-----------|-------|----------|
| **Llama 3.3 70B** | 11445 | 70B | ~40GB | ⚡ 4-7 tok/s | 🔥🔥🔥 | 🔧🔧🔧 | Maximum capability |
| **DeepSeek-V3** | 11444 | 37B | ~18GB | ⚡⚡ 6-10 tok/s | 🔥🔥🔥 | 🔧🔧🔧 | Complex reasoning |
| **Qwen3-32B** | 11443 | 32B | ~18GB | ⚡⚡ 8-12 tok/s | 🔥🔥 | 🔧🔧🔧 | Balanced SOTA |
| **Mixtral 8x7B** | 11446 | 7B | ~18GB | ⚡⚡ 8-12 tok/s | 🔥🔥 | 🔧🔧 | MoE efficiency |
| **Qwen3-VL-32B** | 11447 | 32B | ~20GB | ⚡⚡ 6-10 tok/s | 🔥🔥 | 🔧🔧 | Multimodal |

## Detailed Model Descriptions

### Llama 3.3 70B (Port 11445)

**When to use:**
- You need maximum capability and quality
- Complex reasoning problems
- Expert-level code generation
- Multi-step problem solving with tools

**Strengths:**
- Largest single model
- Top performance on benchmarks
- Excellent instruction following
- Native tool/function calling

**Weaknesses:**
- Slowest (~4-7 tokens/sec)
- ~40GB memory (pushes your limit)
- Overkill for simple tasks

**Memory:**
- Base model: ~35-40GB at 4-bit
- Monitor during first inference
- Run alone if possible

---

### DeepSeek-V3 (Port 11444)

**When to use:**
- Maximum reasoning capability
- Complex tool orchestration
- Scientific/mathematical problems
- Chain-of-thought reasoning needed

**Strengths:**
- Top reasoning performance (per benchmarks)
- Mixture of Experts architecture
- Smart tool selection via reasoning
- Efficient active parameters

**Weaknesses:**
- May require specific prompt formatting
- MoE performance varies by task

**Unique features:**
- 37B active parameters out of 236B
- Smart routing to expert layers
- Excellent chain-of-thought capability

---

### Qwen3-32B (Port 11443)

**When to use:**
- You want state-of-the-art capability
- Good balance of speed and quality
- Code generation and understanding
- General purpose assistant

**Strengths:**
- Latest Qwen architecture (2025)
- Good performance/speed tradeoff
- 32B of pure capability
- Excellent on code tasks
- ~18GB memory

**Performance notes:**
- ~8-12 tokens/sec
- Good at tool use decisions
- Reasonable context window

---

### Mixtral 8x7B (Port 11446)

**When to use:**
- You understand MoE benefits
- Different tools need different "experts"
- Efficient reasoning matters
- Faster responses preferred

**Strengths:**
- Mixture of Experts routing
- Only 7B parameters active at a time
- Faster than single-model alternatives
- Specialized routing per task type

**How MoE helps tools:**
```
Query: "Call weather API"
├─ Router chooses API-calling expert
└─ Uses specialized expert for that tool type

Query: "Analyze image"
├─ Router chooses vision expert  
└─ Uses specialized expert for visual tasks
```

---

### Qwen3-VL-32B (Port 11447)

**When to use:**
- You need image understanding
- Document analysis
- Visual reasoning
- Charts/diagrams/screenshots

**Strengths:**
- Multimodal (text + vision)
- Can call tools based on images
- Latest Qwen3 architecture
- Strong visual understanding

**Typical workflow:**
1. User uploads image
2. Model analyzes with vision
3. Model calls appropriate tools
4. Tools execute based on analysis

---

## Memory Planning

With 20GB available:

### Option 1: Single Large Model (Recommended)
```bash
# Run one of these, best quality
./llama3.3-70b_11445.sh      # Maximum (40GB, monitor)
./deepseek-v3_11444.sh        # Best reasoning (18GB)
./qwen3-32b_11443.sh          # Best balance (18GB)
```

### Option 2: Run Two Models
```bash
# Terminal 1 (18GB)
./qwen3-32b_11443.sh

# Terminal 2 (18GB) - if you have 36GB+
./qwen3-vl-32b_11447.sh
```

### Option 3: Mixed Speed/Capability
```bash
# Terminal 1 - Fast reasoning (18GB)
./deepseek-v3_11444.sh

# Terminal 2 - Fast switching (18GB)
./mixtral-8x7b_11446.sh
```

## Benchmark Performance (2025)

Based on latest benchmarks from major leaderboards:

### Reasoning (AIME, MATH)
1. **DeepSeek-V3** - Top score
2. Llama 3.3 70B - Second
3. Qwen3-32B - Third

### General Knowledge (MMLU)
1. **Llama 3.3 70B** - ~86%
2. **DeepSeek-V3** - ~85%
3. **Qwen3-32B** - ~84%

### Code (HumanEval)
1. **Qwen3-32B** - Best on code tasks
2. Llama 3.3 70B
3. DeepSeek-V3

### Long Context (200K tokens)
1. DeepSeek-V3 - Native support
2. Llama 3.3 70B - 8K default
3. Qwen3-32B - 8K default

---

## Running Multiple Models Simultaneously

If you want to run multiple models for comparison or specialization:

```bash
# Terminal 1 - General purpose (18GB)
./qwen3-32b_11443.sh &

# Terminal 2 - Reasoning (18GB) 
./deepseek-v3_11444.sh &

# Monitor in third terminal
watch -n 5 'ps aux | grep vllm_mlx'
top -l 1 | grep python
```

Monitor memory usage:
```bash
# Check unified memory
system_profiler SPHardwareDataType | grep Memory

# Watch during inference
Activity Monitor > Memory tab
```

---

## API Examples

### Basic Chat
```bash
curl -X POST http://localhost:11443/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Qwen3-32B-Instruct-2507-4bit",
    "messages": [
      {"role": "user", "content": "Explain quantum computing in simple terms"}
    ],
    "temperature": 0.7,
    "max_tokens": 500
  }'
```

### With Tools/Functions
```bash
curl -X POST http://localhost:11443/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Qwen3-32B-Instruct-2507-4bit",
    "messages": [
      {"role": "user", "content": "What is the current weather and temperature in NYC?"}
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "name": "get_weather",
          "description": "Get current weather for a location",
          "parameters": {
            "type": "object",
            "properties": {
              "location": {"type": "string"},
              "unit": {"type": "string", "enum": ["C", "F"]}
            },
            "required": ["location"]
          }
        }
      }
    ]
  }'
```

### Vision (Qwen3-VL Only)
```bash
curl -X POST http://localhost:11447/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mlx-community/Qwen3-VL-32B-Instruct-2507-6bit",
    "messages": [
      {
        "role": "user",
        "content": [
          {"type": "text", "text": "What is in this image?"},
          {"type": "image_url", "image_url": {"url": "file:///path/to/image.jpg"}}
        ]
      }
    ],
    "max_tokens": 500
  }'
```

---

## Comparison with Previous Smaller Models

| Aspect | Functionary-Small (4.5B) | Qwen3-32B | Llama 3.3 70B |
|--------|--------------------------|-----------|---------------|
| Speed | ⚡⚡⚡ 25-30 tok/s | ⚡⚡ 8-12 tok/s | ⚡ 4-7 tok/s |
| Memory | 3GB | 18GB | 40GB |
| Reasoning | Basic | Advanced | Expert |
| Tool accuracy | Good | Excellent | Expert |
| Knowledge | Limited | Broad | Comprehensive |
| Best use | Fast APIs | Balanced | Complex problems |

**Verdict:** The larger SOTA models are worth the speed tradeoff if you have memory. Better reasoning means better tool selection and fewer failed tool calls.

---

## Troubleshooting

**Model too slow?**
→ Use Qwen3-32B or Mixtral instead of Llama 70B

**Running out of memory?**
→ Use Qwen3-32B (18GB) instead of Llama (40GB)
→ Close other applications
→ Use Activity Monitor to verify memory

**Model takes forever to load?**
→ First load does quantization/optimization
→ Subsequent loads are faster
→ Be patient with Llama 70B (can take 30-60s)

**Tool calls not working?**
→ DeepSeek-V3 has best reasoning for tool selection
→ Llama 3.3 70B has most reliable tool calling
→ Check tool format matches OpenAI spec

---

## Sources

- [Onyx AI Self-Hosted LLM Leaderboard 2026](https://onyx.app/self-hosted-llm-leaderboard) - Latest model rankings
- [vllm-mlx Models Reference](https://github.com/waybarrios/vllm-mlx/blob/main/docs/reference/models.md) - Supported models and memory requirements
- [MLX Community Models](https://huggingface.co/mlx-community) - Latest MLX quantized models

#!/bin/bash
# Qwen3-30B-A3B-Instruct-2507 - MoE (3B active), non-thinking instruct variant
# Size: 30B total, ~3B active, 4-bit quantization
# Memory: ~17GB
# Context: 256K native
# Best for: agentic tool-calling loops; MoE keeps tok/s high on Apple Silicon
# Tool use: native OpenAI-shape tool_calls
# Port: 11456

exec "$(dirname "$0")/_launch.sh" vllm_mlx.server mlx-community/Qwen3-30B-A3B-Instruct-2507-4bit 11456

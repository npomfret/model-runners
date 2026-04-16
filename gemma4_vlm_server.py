#!/usr/bin/env python3
"""
Gemma 4 31B MLX Vision-Language Model Server
Serves via OpenAI-compatible API
"""

import argparse
import json
from pathlib import Path
from typing import Optional

from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
import uvicorn

from mlx_vlm import load, generate


app = FastAPI()
model = None
processor = None


@app.on_event("startup")
async def startup():
    global model, processor
    model, processor = load("mlx-community/gemma-4-31b-8bit")
    print("✓ Gemma 4 31B model loaded")


@app.get("/v1/models")
async def list_models():
    """OpenAI-compatible models endpoint"""
    return {
        "object": "list",
        "data": [
            {
                "id": "gemma-4-31b-8bit",
                "object": "model",
                "created": 1700000000,
                "owned_by": "mlx-community",
            }
        ],
    }


@app.post("/v1/chat/completions")
async def chat_completions(request: dict):
    """OpenAI-compatible chat completions endpoint"""
    if not model:
        raise HTTPException(status_code=503, detail="Model not loaded")

    messages = request.get("messages", [])
    max_tokens = request.get("max_tokens", 512)
    temperature = request.get("temperature", 0.7)

    # Extract text from messages - format as simple prompt
    prompt_text = ""
    for msg in messages:
        role = msg.get("role", "user")
        content = msg.get("content", "")
        if role == "system":
            prompt_text += f"System: {content}\n\n"
        else:
            prompt_text += f"{role.capitalize()}: {content}\n"

    # Generate response
    try:
        # Cap max_tokens at 200 to prevent runaway generations
        capped_max_tokens = min(max_tokens, 200) if max_tokens else 200
        result = generate(
            model,
            processor,
            prompt_text,
            max_tokens=capped_max_tokens,
            temperature=temperature,
        )
        # Extract text from GenerationResult object
        output = result.text if hasattr(result, 'text') else str(result)
        # Clean up: stop at conversation markers
        lines = output.split('\n')
        clean_output = []
        for line in lines:
            if any(marker in line for marker in ['User:', 'A:', 'Assistant:', 'Q:']):
                break
            clean_output.append(line)
        output = '\n'.join(clean_output).strip()

        return {
            "id": "gemma-4-31b",
            "object": "chat.completion",
            "created": int(__import__('time').time()),
            "model": "gemma-4-31b-8bit",
            "choices": [
                {
                    "index": 0,
                    "message": {
                        "role": "assistant",
                        "content": output,
                    },
                    "finish_reason": "stop",
                }
            ],
            "usage": {
                "prompt_tokens": result.prompt_tokens if hasattr(result, 'prompt_tokens') else len(prompt_text.split()),
                "completion_tokens": result.generation_tokens if hasattr(result, 'generation_tokens') else len(output.split()),
                "total_tokens": result.total_tokens if hasattr(result, 'total_tokens') else len(prompt_text.split()) + len(output.split()),
            },
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def chat_mode(system_prompt: Optional[str] = None):
    """Interactive chat mode"""
    global model, processor
    if not model:
        model, processor = load("mlx-community/gemma-4-31b-8bit")
        print("✓ Gemma 4 31B model loaded\n")

    if system_prompt:
        print(f"System: {system_prompt}\n")

    print("Starting Gemma 4 Chat (type 'exit' to quit)\n")

    while True:
        try:
            user_input = input("You: ").strip()
            if user_input.lower() in ["exit", "quit"]:
                print("Goodbye!")
                break
            if not user_input:
                continue

            # Build prompt with system context
            if system_prompt:
                prompt = f"System: {system_prompt}\n\nUser: {user_input}\nAssistant:"
            else:
                prompt = f"User: {user_input}\nAssistant:"

            print("", end="", flush=True)
            result = generate(
                model,
                processor,
                prompt,
                max_tokens=200,
                temperature=0.7,
            )
            # Extract text from GenerationResult object
            output = result.text if hasattr(result, 'text') else str(result)
            # Clean up: stop at conversation markers (User:, A:, Assistant:)
            lines = output.split('\n')
            clean_output = []
            for line in lines:
                if any(marker in line for marker in ['User:', 'A:', 'Assistant:', 'Q:']):
                    break
                clean_output.append(line)
            output = '\n'.join(clean_output).strip()
            print(output)
            print()
        except KeyboardInterrupt:
            print("\nGoodbye!")
            break
        except Exception as e:
            print(f"Error: {e}\n")


def main():
    parser = argparse.ArgumentParser(description="Gemma 4 31B MLX Server")
    parser.add_argument("--mode", choices=["server", "chat"], default="server",
                        help="Run in server mode (API) or chat mode (interactive)")
    parser.add_argument("--host", default="0.0.0.0", help="Server host")
    parser.add_argument("--port", type=int, default=11435, help="Server port")
    parser.add_argument("-s", "--system", type=str, default=None,
                        help="System prompt for chat mode")
    args = parser.parse_args()

    if args.mode == "chat":
        chat_mode(system_prompt=args.system)
    else:
        print(f"Starting Gemma 4 31B server on {args.host}:{args.port}")
        uvicorn.run(app, host=args.host, port=args.port)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Gemma 4 MLX Vision-Language Model Server
Serves via OpenAI-compatible API (/v1/models, /v1/chat/completions).
"""

import argparse
import json
import time
import uuid
from typing import Optional

from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
import uvicorn

from mlx_vlm import load, generate, stream_generate
from mlx_vlm.prompt_utils import apply_chat_template


app = FastAPI()
model = None
processor = None
MODEL_NAME = "mlx-community/gemma-4-31b-8bit"


@app.on_event("startup")
async def startup():
    global model, processor
    model, processor = load(MODEL_NAME)
    print(f"✓ {MODEL_NAME} loaded")


@app.get("/v1/models")
async def list_models():
    return {
        "object": "list",
        "data": [
            {
                "id": MODEL_NAME,
                "object": "model",
                "created": 1700000000,
                "owned_by": MODEL_NAME.split("/")[0] if "/" in MODEL_NAME else "local",
            }
        ],
    }


def _build_prompt(messages):
    # Gemma 4 produces garbage output without its chat template applied.
    return apply_chat_template(
        processor,
        model.config,
        messages,
        add_generation_prompt=True,
    )


def _finish_reason(generation_tokens: int, max_tokens: int) -> str:
    return "length" if generation_tokens >= max_tokens else "stop"


@app.post("/v1/chat/completions")
async def chat_completions(request: dict):
    if not model:
        raise HTTPException(status_code=503, detail="Model not loaded")

    messages = request.get("messages", [])
    max_tokens = request.get("max_tokens") or 512
    temperature = request.get("temperature", 0.7)
    top_p = request.get("top_p", 1.0)
    stream = bool(request.get("stream", False))

    prompt_text = _build_prompt(messages)

    request_id = f"chatcmpl-{uuid.uuid4().hex}"
    created = int(time.time())

    gen_kwargs = {
        "max_tokens": max_tokens,
        "temperature": temperature,
        "top_p": top_p,
    }

    if stream:
        def event_stream():
            # First chunk announces the role, subsequent chunks carry content deltas.
            head = {
                "id": request_id,
                "object": "chat.completion.chunk",
                "created": created,
                "model": MODEL_NAME,
                "choices": [
                    {"index": 0, "delta": {"role": "assistant"}, "finish_reason": None}
                ],
            }
            yield f"data: {json.dumps(head)}\n\n"

            last_response = None
            try:
                for response in stream_generate(
                    model, processor, prompt_text, **gen_kwargs
                ):
                    last_response = response
                    if not response.text:
                        continue
                    chunk = {
                        "id": request_id,
                        "object": "chat.completion.chunk",
                        "created": created,
                        "model": MODEL_NAME,
                        "choices": [
                            {
                                "index": 0,
                                "delta": {"content": response.text},
                                "finish_reason": None,
                            }
                        ],
                    }
                    yield f"data: {json.dumps(chunk)}\n\n"
            except Exception as e:
                err = {"error": {"message": str(e), "type": "server_error"}}
                yield f"data: {json.dumps(err)}\n\n"
                yield "data: [DONE]\n\n"
                return

            gen_tokens = last_response.generation_tokens if last_response else 0
            final = {
                "id": request_id,
                "object": "chat.completion.chunk",
                "created": created,
                "model": MODEL_NAME,
                "choices": [
                    {
                        "index": 0,
                        "delta": {},
                        "finish_reason": _finish_reason(gen_tokens, max_tokens),
                    }
                ],
            }
            yield f"data: {json.dumps(final)}\n\n"
            yield "data: [DONE]\n\n"

        return StreamingResponse(event_stream(), media_type="text/event-stream")

    try:
        result = generate(model, processor, prompt_text, **gen_kwargs)
        output = (result.text if hasattr(result, "text") else str(result)).strip()
        prompt_tokens = getattr(result, "prompt_tokens", 0)
        completion_tokens = getattr(result, "generation_tokens", 0)
        total_tokens = getattr(result, "total_tokens", prompt_tokens + completion_tokens)

        return {
            "id": request_id,
            "object": "chat.completion",
            "created": created,
            "model": MODEL_NAME,
            "choices": [
                {
                    "index": 0,
                    "message": {"role": "assistant", "content": output},
                    "finish_reason": _finish_reason(completion_tokens, max_tokens),
                }
            ],
            "usage": {
                "prompt_tokens": prompt_tokens,
                "completion_tokens": completion_tokens,
                "total_tokens": total_tokens,
            },
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


def chat_mode(system_prompt: Optional[str] = None):
    """Interactive chat mode"""
    global model, processor
    if not model:
        model, processor = load(MODEL_NAME)
        print(f"✓ {MODEL_NAME} loaded\n")

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

            chat_messages = []
            if system_prompt:
                chat_messages.append({"role": "system", "content": system_prompt})
            chat_messages.append({"role": "user", "content": user_input})
            prompt = _build_prompt(chat_messages)

            result = generate(
                model,
                processor,
                prompt,
                max_tokens=512,
                temperature=0.7,
            )
            output = result.text if hasattr(result, "text") else str(result)
            print(output.strip())
            print()
        except KeyboardInterrupt:
            print("\nGoodbye!")
            break
        except Exception as e:
            print(f"Error: {e}\n")


def main():
    parser = argparse.ArgumentParser(description="Gemma 4 MLX Server")
    parser.add_argument("--model", default="mlx-community/gemma-4-31b-8bit",
                        help="HuggingFace model ID (mlx-vlm compatible)")
    parser.add_argument("--mode", choices=["server", "chat"], default="server",
                        help="Run in server mode (API) or chat mode (interactive)")
    parser.add_argument("--host", default="0.0.0.0", help="Server host")
    parser.add_argument("--port", type=int, default=11435, help="Server port")
    parser.add_argument("-s", "--system", type=str, default=None,
                        help="System prompt for chat mode")
    args = parser.parse_args()

    global MODEL_NAME
    MODEL_NAME = args.model

    if args.mode == "chat":
        chat_mode(system_prompt=args.system)
    else:
        print(f"Starting {MODEL_NAME} server on {args.host}:{args.port}")
        uvicorn.run(app, host=args.host, port=args.port)


if __name__ == "__main__":
    main()

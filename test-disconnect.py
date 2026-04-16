#!/usr/bin/env python3
"""Test client disconnect behavior - closes connection before response completes."""

import requests
import time
import sys
from threading import Thread

def test_disconnect(prompt: str, disconnect_delay: float = 0.1):
    """Send request and disconnect early."""
    url = "http://localhost:11449/v1/completions"

    payload = {
        "model": "mlx-community/Phi-3-mini-128k-instruct-4bit",
        "prompt": prompt,
        "max_tokens": 200,
        "temperature": 0.7,
        "stream": True,
    }

    print(f"\n[TEST] Sending: {prompt[:60]}...")
    print(f"[TEST] Will disconnect after {disconnect_delay}s")

    try:
        response = requests.post(url, json=payload, stream=True, timeout=5)

        # Read a bit, then close
        start = time.time()
        for line in response.iter_lines():
            elapsed = time.time() - start
            if elapsed > disconnect_delay:
                print(f"[TEST] Closing connection after {elapsed:.2f}s")
                response.close()
                break
            if line:
                print(f"[RESPONSE] {line.decode() if isinstance(line, bytes) else line}")
    except requests.exceptions.RequestException as e:
        print(f"[ERROR] {e}")

if __name__ == "__main__":
    # Test a few times
    tests = [
        ("What is the capital of France?", 0.2),
        ("Explain quantum computing in simple terms.", 0.3),
        ("Write a short poem about the moon.", 0.2),
    ]

    for prompt, delay in tests:
        test_disconnect(prompt, delay)
        time.sleep(1)

    print("\n[DONE] Watch GPU usage - should drop after each disconnect")

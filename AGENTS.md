# mlx-server

Launch scripts for running open-source LLMs on Apple Silicon through a patched `vllm-mlx`. Python 3.12 with `uv` (`pyproject.toml`); mlx-lm, mlx-vlm, FastAPI. There is one script per model, named `<model>_<port>.sh` with ports in the 11443-11467 range, built on the shared `_launch.sh`. The local `.patch` files target `vllm-mlx` 0.2.7, so check them before changing that version.

Lifecycle: not evidenced (status unknown); personal tooling with no deploy target.

<!-- agent-standards:begin -->
## Shared agent guidance

Before starting work, read [Git](.agents/agent-standards/guidance/git.md).
Keep the shared checkout on its default branch. Use detached worktrees. Agents commit, fast-forward land and push their verified, reviewed work.

*Managed by `npomfret/agent-standards`; edit the shared sources there.*
<!-- agent-standards:end -->

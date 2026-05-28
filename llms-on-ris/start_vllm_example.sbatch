#!/bin/bash
#SBATCH --partition=general-gpu
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --gres=gpu:H100:1
#SBATCH --time=30:00
#SBATCH --container-image=vllm/vllm-openai:latest
#SBATCH --container-mounts=<path-to-your-active-directory>
#SBATCH --output=<path-to-curr-directory>/ris-tips/llms-on-ris/logs/vllm-%j.log
#SBATCH --error=<path-to-curr-directory>/ris-tips/llms-on-ris/logs/vllm-%j.err


# Slurm/module env often sets CC/CXX to /opt/thpc/.../gcc — paths that do not exist
# inside the container and break vLLM/triton JIT. Use compilers from PATH in the image.
unset CC CXX CUDAHOSTCXX
if command -v gcc >/dev/null 2>&1; then export CC="$(command -v gcc)"; fi
if command -v g++ >/dev/null 2>&1; then export CXX="$(command -v g++)"; fi

export MODEL=openai/gpt-oss-20b
export NUM_GPUS=1
export HF_HUB_CACHE=<path-to-hf_cache/hub/>
export HOME=<path-to-your-home-directory>
CHAT_PORT=8100

echo "OpenAI-compatible chat: http://$(hostname -s):${CHAT_PORT}/v1/"
python3 -m vllm.entrypoints.openai.api_server \
  --model "$MODEL" \
  --reasoning-parser openai_gptoss \
  --tool-call-parser openai \
  --enable-auto-tool-choice \
  --host 0.0.0.0 \
  --port "$CHAT_PORT" \
  --tensor-parallel-size "$NUM_GPUS" \
  --gpu-memory-utilization 0.85 \
  --max-model-len 131072 \
  --max-num-batched-tokens 10240 \
  --max-num-seqs 128 \
  --no-enable-prefix-caching
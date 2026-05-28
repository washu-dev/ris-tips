#!/bin/bash
MODEL=openai/gpt-oss-20b
HOST=c2-gpu-013
PORT=8100

curl -s -X POST http://$HOST:$PORT/v1/chat/completions \
    --header "Content-Type: application/json" \
    --data '{"model":"openai/gpt-oss-20b","messages":[{"role":"user","content":"Say hello."}],"max_tokens":500}'

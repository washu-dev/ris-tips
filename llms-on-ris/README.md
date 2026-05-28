# Running LLMs on RIS

## VLLM

We will use [vllm](https://github.com/vllm-project/vllm) to host a large language model on RIS and access it just like an OpenAI endpoint.

This instruction is for RIS `compute2` that uses a SLURM scheduler. 

1. Look at `start_vllm_example.sbatch`

Modify the following lines:

```
#SBATCH --container-mounts=<path-to-your-active-directory>
#SBATCH --output=<path-to-curr-directory>/ris-tips/llms-on-ris/logs/vllm-%j.log
#SBATCH --error=<path-to-curr-directory>/ris-tips/llms-on-ris/logs/vllm-%j.err
...
export HF_HUB_CACHE=<path-to-hf_cache/hub/>
export HOME=<path-to-your-home-directory>
```

For the `HF_HUB_CACHE`, make sure you are using a path in your Active directory.
Similarly for `HOME`, do not use `/home/wustl-id` as that has limited storage.

### Important

Ensure that a `export HF_TOKEN=` exists in your `~/.bashrc` and you have accepted the terms and agreement for the model you have chosen.

2. You can edit the model name, and its configuration as well. In this example we are using a `gpt-oss-20b` parameter model.

```
export MODEL=openai/gpt-oss-20b
```

3. Ensure that the `--time` flag is set, so that the job does not run indefinitely.

4. After editing the `start_vllm_example.sbatch` file, submit it as a job.

```
sbatch start_vllm_example.sbatch
```

5. The first time a particular model is run, the model will be downloaded to your HF_CACHE. If you get an error about a missing HF (HuggingFace) token, make sure that a valid `HF_TOKEN` environment variable exists.

In your `vllm-<job-id>`, the model is ready when you see the following lines:
```
(APIServer pid=378117) INFO:     Started server process [378117]
(APIServer pid=378117) INFO:     Waiting for application startup.
(APIServer pid=378117) INFO:     Application startup complete.
```

6. In the generated log or using `squeue` see which node the job is running on. This will be our host name. Edit `inference.sh` with this host. Ensure the model name matches that of your `start_vllm_example.sbatch` and run the inference file:

```
bash inference.sh
```

If successful, you should see a response like this:
```
{
    "id": "chatcmpl-9e9f26cfed40bd76",
    "object": "chat.completion",
    "created": 1779979246,
    "prompt_routed_experts": null,
    "model": "openai/gpt-oss-20b",
    "choices": [
        {
            "index": 0,
            "message": {
                "role": "assistant",
                "content": "Hello!",
                "refusal": null,
                "annotations": null,
                "audio": null,
                "function_call": null,
                "tool_calls": [],
                "reasoning": "User says \"Say hello.\" Likely expects a greeting. There's no special instructions. Just say hello. Maybe say \"Hello!\""
            },
            "logprobs": null,
            "finish_reason": "stop",
            "stop_reason": null,
            "token_ids": null,
            "routed_experts": null
        }
    ],
    "service_tier": null,
    "system_fingerprint": "vllm-0.21.0-81307614",
    "usage": {
        "prompt_tokens": 70,
        "total_tokens": 108,
        "completion_tokens": 38,
        "prompt_tokens_details": null
    },
    "prompt_logprobs": null,
    "prompt_token_ids": null,
    "prompt_text": null,
    "kv_transfer_params": null
}
```
Note that this particular variant of `gpt-oss-20b` has reasoning enabled which can be changed in the model flags.

### Advanced

So far we are able to query (run inference) the model on the login node of RIS. We can also query the model locally, say on your laptop. 

1. Ensure you can connected to the [WashU VPN](https://it.wustl.edu/items/connect/) or are on campus WiFi.

2. On a new terminal window, tunnel into RIS.
```
ssh -L 8100:<compute-node>:8100 wustl-id@c2-login-001.ris.wustl.edu
```
Ensure that the `compute-node` matches the node that the VLLM server is running on (ex: c2-gpu-013).
Ensure the `PORT` is the same as you have in the `start_vllm_example.sbatch`.

3. On a new local terminal, copy the `inference.sh` file. Chance the host to `localhost`. Run `inference.sh`.
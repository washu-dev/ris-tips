# SLURM Basics

[SLURM](https://slurm.schedmd.com/documentation.html) is the job scheduler used on RIS Compute2. It manages resources across the cluster so jobs are fairly allocated. You should never run heavy compute directly on the login node; always submit through SLURM.

---

## Checking the Cluster

### `sinfo` - View partitions and node availability

```bash
sinfo
```

Key partitions on Compute2:

| Partition | Max Time | Notes |
|---|---|---|
| `general-interactive` | 5 days | For interactive sessions (Jupyter, terminals) |
| `general-cpu` | 15 days | Standard CPU jobs |
| `general-gpu` | 15 days | GPU jobs |
| `general-bigmem` | 15 days | High-memory jobs |
| `general-preempt-cpu` | 15 days | Lower priority, can be preempted |
| `general-preempt-gpu` | 15 days | Lower priority GPU, can be preempted |

Node states: `idle` (free), `mix` (partially used), `alloc` (fully used), `drain` (taken offline).

---

### `squeue` — View the job queue

```bash
squeue                  # all jobs
squeue --me             # only your jobs
squeue -u wustl-id      # jobs for a specific user
squeue -p general-gpu   # jobs in a specific partition
```

Common output columns: `JOBID`, `PARTITION`, `NAME`, `USER`, `ST` (status), `TIME` (elapsed), `NODES`, `NODELIST`.

Job statuses: `PD` (pending), `R` (running), `CG` (completing).

---

## Running Jobs

### `srun` — Interactive jobs

Launches a job and gives you a shell or runs a command directly.

**Multiple accounts:** If you belong to more than one lab or allocation group, you must specify which account to charge with `--account`. To see your available accounts:

```bash
sacctmgr show user $(whoami) withassoc format=account%30,partition%30
```
It typically shows `compute2-<PI-name>`

Then pass the account explicitly:

```bash
srun --account=<account-name> --partition=general-gpu --gres=gpu:1 --mem=32G --pty bash
```

Without `--account`, SLURM picks one for you which may not be the one you intend.
You may need to replace `--gres=gpu:1` to `--gres=gpu:H100:1` in certain cases.

```bash
# Interactive shell
srun --partition=general-interactive --mem=16G --cpus-per-task=4 --time=2:00:00 --pty bash

# Run a single command
srun --partition=general-cpu --mem=8G --cpus-per-task=2 python train.py

# Interactive GPU session
srun --partition=general-interactive --gres=gpu:1 --mem=32G --time=4:00:00 --pty bash
```

---

### `sbatch` — Batch jobs

Submit a script to run non-interactively. Create a file `job.sbatch`:

```bash
#!/bin/bash
#SBATCH --job-name=my-job
#SBATCH --partition=general-cpu
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --output=logs/%j.out    # %j is replaced by job ID
#SBATCH --error=logs/%j.err

python train.py
```

Then submit:

```bash
sbatch job.sbatch
```

You can run `example.sbatch` for a working example. You may have to change the `#SBATCH --account=compute2-workshop` to your account name:
```bash
sbatch example.sbatch
```

For GPU jobs, add:

```bash
#SBATCH --partition=general-gpu
#SBATCH --gres=gpu:1
```

> **Always set `--time` for long jobs.** Without it, your job runs until the partition's maximum time limit, which wastes resources and can block others. Set it as close to your expected runtime as possible.

---

## Managing Jobs

### `scancel` — Cancel a job

```bash
scancel <jobid>         # cancel a specific job
scancel --me            # cancel all your jobs
```

### `sacct` — Job history and resource usage

```bash
sacct                                      # your recent jobs
sacct -j <jobid>                           # specific job
sacct -j <jobid> --format=JobID,Elapsed,MaxRSS,State
```

Useful for checking how much memory or time a completed job actually used.

---

## Common `srun`/`sbatch` Flags

| Flag | Description |
|---|---|
| `--partition` / `-p` | Which partition to use |
| `--cpus-per-task` / `-c` | Number of CPU cores |
| `--mem` | Total memory (e.g. `16G`) |
| `--time` / `-t` | Time limit (`HH:MM:SS` or `D-HH:MM:SS`) |
| `--gres=gpu:N` | Request N GPUs |
| `--job-name` / `-J` | Name for the job |
| `--output` / `-o` | File for stdout |
| `--error` / `-e` | File for stderr |
| `--account` / `-A` | Billing account (if required) |

---

## Tips

- **Don't run jobs on the login node.** Use `srun` for interactive work and `sbatch` for longer jobs.
- **Request only what you need.** Requesting excess CPUs/memory keeps your job in the queue longer.
- **Use `sacct` after a job** to right-size your next submission - check actual vs. requested memory.
- **Preempt partitions** (`general-preempt-*`) are good for jobs that can be checkpointed or restarted, since they have less competition.

#!/bin/bash
#SBATCH --job-name=hello
#SBATCH --account=compute2-workshop
#SBATCH --partition=general-cpu
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=0:05:00
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err

mkdir -p logs

echo "Running job $SLURM_JOB_ID on $(hostname) at $(date)"

python hello.py

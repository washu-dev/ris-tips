#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --account=compute2-workshop
#SBATCH --partition=general-cpu
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=1:00:00
#SBATCH --output=logs/%j.out
#SBATCH --error=logs/%j.err
#SBATCH --container-image=docker://quay.io\#jupyter/scipy-notebook:latest
#SBATCH --container-mounts=/storage2/fs1/<PI-name>/Active/<path-to-workdir>:/storage2/fs1/<PI-name>/Active/<path-to-workdir>
#SBATCH --container-workdir=/storage2/fs1/<PI-name>/Active/<path-to-workdir>

mkdir -p logs

PORT=8989
echo "Node: $SLURMD_NODENAME"
echo "Port: $PORT"
echo "SSH tunnel: ssh -L $PORT:$SLURMD_NODENAME:$PORT compute2"

jupyter lab --no-browser --ip='0.0.0.0' --port=$PORT

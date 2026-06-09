# Jupyter on RIS

Run JupyterLab on a compute node using a container image via [Pyxis](https://github.com/NVIDIA/pyxis).

> **Easier alternative:** [RIS Open OnDemand (OOD)](https://ris.wustl.edu/open-ondemand/) provides a browser-based interface to launch Jupyter without any terminal setup.

---

## Batch (sbatch)

Two example scripts are provided — one for CPU and one for GPU. Before submitting, update the account and paths in whichever you use:

```bash
#SBATCH --account=compute2-<PI-name>
#SBATCH --container-mounts=/storage2/fs1/<PI-name>/Active/<path>:/storage2/fs1/<PI-name>/Active/<path>
#SBATCH --container-workdir=/storage2/fs1/<PI-name>/Active/<path>
```

> **Note:** Use `docker://quay.io\#` (with a backslash) in `#SBATCH` headers to escape the `#` — without it, the rest of the line is treated as a comment.

> **Account priority:** The `compute2-workshop` account has `Priority=0` and will not get GPU allocations. Use `compute2-<PI-name>` for GPU jobs.

### CPU

```bash
sbatch jupyter_cpu.sbatch
```

- Partition: `general-cpu`
- Image: `quay.io/jupyter/scipy-notebook` (Python, pandas, numpy, matplotlib, scipy, scikit-learn)

### GPU

```bash
sbatch jupyter_gpu.sbatch
```

- Partition: `general-gpu`
- Image: `quay.io/jupyter/pytorch-notebook:cuda12-python-3.13` (PyTorch + CUDA)
- Requests 1 GPU (`--gres=gpu:1`)

---

## Connecting

The job prints the node, port, and SSH tunnel command to `logs/<jobid>.out`:

```bash
tail -f logs/<jobid>.out
```

VS Code's auto port forwarding only works when connected to the **login node**, but Jupyter runs on a **compute node** — so you need a manual SSH tunnel from your local machine:

```bash
ssh -L 8989:<compute-node>:8989 compute2
```

If port `8989` is already in use locally, pick a different local port:

```bash
ssh -L 18989:<compute-node>:8989 compute2
```

Then open the URL Jupyter printed (with the token) in your browser:

```
http://localhost:8989/lab?token=...
```

---

## Container Images

All `quay.io/jupyter` images have JupyterLab pre-installed. NVIDIA NGC images do not.

| Image | Contents |
|---|---|
| `quay.io/jupyter/scipy-notebook` | Python, pandas, numpy, matplotlib, scipy, scikit-learn |
| `quay.io/jupyter/datascience-notebook` | Above + R and Julia |
| `quay.io/jupyter/pytorch-notebook` | Above + PyTorch with CUDA |
| `quay.io/jupyter/tensorflow-notebook` | Above + TensorFlow with CUDA |

Images are pulled from quay.io at job start and cached by enroot on the compute node. To avoid re-pulling on every job, pre-cache the image as a `.sqsh` file:

```bash
enroot import docker://quay.io#jupyter/scipy-notebook:latest
```

Then reference it in your sbatch:

```bash
#SBATCH --container-image=/path/to/scipy-notebook.sqsh
```

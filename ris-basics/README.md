# RIS Basics

## Connecting to RIS

### Connect to WashU Network

**On campus**

You need to be on the WashU network. Typically connect to `wustl2.0` or `WUSM-secure`.

**Off-campus**

You need to be on the [WashU VPN](https://it.wustl.edu/items/connect/).

1. Download the Cisco AnyConnect client
2. Enter your server:
   - Danforth customers: `danforthvpn.wustl.edu`
   - Medical School customers: `msvpn.wusm.wustl.edu`
3. Sign in using your WashU credentials


### RIS Compute2 Login

Open a terminal (Mac/Linux) or install [Git Bash](https://git-scm.com/downloads) / [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) on Windows, then run:

```bash
ssh wustl-id@c2-login-001.ris.wustl.edu
```

> **Bonus:** Set up [SSH key exchange](https://www.ssh.com/academy/ssh/keygen) to avoid typing your password each time.

## Better workflow

### SSH Config File

On your computer, add the following to `~/.ssh/config`:
```
Host compute2
    Hostname c2-login-001.ris.wustl.edu
    User wustl-id
    Port 22
```
On a new terminal, try `ssh compute2`. This serves as a shortcut.

> **Windows (WSL) note:** WSL has its own `~/.ssh/config` separate from Windows. If VS Code or other Windows apps aren't picking up the config, also add it to `C:\Users\<your-username>\.ssh\config`.


### Use VS Code

1. Download and install [VS Code](https://code.visualstudio.com/)
2. Install the [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension by Microsoft
3. Click the `><` icon in the bottom-left corner of the VS Code window and select **Connect to Host**

> **Tip:** If you set up the SSH config above, `compute2` will appear as a saved host.

## Storage Allocation

Navigate to your working directory:

```bash
cd /storageN/fs1/<PI-name>/Active/common
```

### Directory Structure

```
Active/common/
├── users/
│   ├── user1/
│   └── user2/
├── projects/
│   ├── project1/
│   └── project2/
├── datasets/
└── models/
```

Since most labs use the same datasets and models (e.g. from [HuggingFace](https://huggingface.co)), the `datasets/` and `models/` directories help prevent downloading redundant data. 
However, for more secure storage hierarchy, see [Secure Projects](../secure-projects/README.md). 

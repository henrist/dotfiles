# AGENTS.md

## Repository overview

**Public repository** (`henrist/dotfiles` on GitHub). Everything committed is world-readable.

Personal dotfiles for shell, git, vim, tmux, gnupg, and related tooling across machines. Not a library or app.

### Structure

```
install.sh            # Root installer — runs each component's install.sh
bash/                 # bashrc + git prompt helpers
git/                  # shared gitconfig (included from ~/.gitconfig)
gnupg/                # gpg-agent.conf
keys/                 # SSH/key setup
tmux/                 # tmux.conf + AI/Claude hook helpers
vim/                  # vimrc + core/ide splits, vim-plug bootstrap
ctags/                # ctags config
testenv/              # Docker test environment
```

Each component has its own `install.sh`. Root `./install.sh` orchestrates them.

## Workflow

Install on a machine:

```bash
./install.sh
```

Or run a single component:

```bash
cd <component> && ./install.sh
```

Install scripts are mostly idempotent: skip or upgrade when targets already exist. Prefer include/symlink into home (`~/.gitconfig` includes repo gitconfig; bashrc sources repo bashrc) so host-local tools can still write local config without mutating the checkout.

Commit after completing work. Ask before committing if unsure whether the change belongs in the repo.

Because this is public: never commit secrets or identifying personal details without asking first.

## Build / test / lint

None required. Verify manually:

```bash
./install.sh
# or a single component install.sh
bash -n install.sh bash/install.sh   # syntax check shell scripts
```

`testenv/` has a Docker-based smoke environment if needed.

## Code style

### Shell (bash)

- `#!/bin/bash` with `set -eu`
- Quote variables: `"$var"`, `"$@"`
- Prefer `[[ ]]` for conditionals
- Derive paths from script location when needed: `SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"`
- Idempotent installers: check before linking/writing; exit cleanly if already set up
- Errors to stderr: `echo "Error: ..." >&2`
- Reserve uppercase for system and environment variables

### General

- Concise over verbose. Simple over clever.
- LF line endings only.
- Zero comments by default; only non-obvious WHY or footguns.

#!/bin/bash
set -eu

if [ -e ~/.gitconfig ]; then
    echo "Git is already set up"
    exit
fi

echo "Setting up git-config"

# Write a regular ~/.gitconfig that includes the dotfiles base config, instead
# of symlinking. This way tools (gh auth setup-git, Ansible, etc.) can write
# host-local entries to ~/.gitconfig without mutating the dotfiles checkout.
cat > ~/.gitconfig <<EOF
[include]
	path = $(pwd)/gitconfig
EOF

#!/bin/bash
set -eu

if [ -e ~/.gitconfig ]; then
    echo "Git is already set up"
    exit
fi

echo "Setting up git-config"

ln -s "$(pwd)/gitconfig" ~/.gitconfig

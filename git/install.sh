#!/bin/bash
. $(dirname $0)/../include.sh

if [ -e ~/.gitconfig ]; then
    echo "Git is already set up"
    exit 2
fi

echo "Setting up git-config"

ln -s "`pwd`/gitconfig" ~/.gitconfig

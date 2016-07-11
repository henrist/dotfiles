#!/bin/bash
. $(dirname $0)/../include.sh

if [ -e ~/.gitconfig ]; then
    info "Git is already set up"
    exit 2
fi

info "Setting up git-config"

ln -s "`pwd`/gitconfig" ~/.gitconfig

#!/bin/bash
. $(dirname $0)/../include.sh

if [ -e ~/.tmux.conf ]; then
    echo "Tmux is already set up"
    exit 2
fi

echo "Setting up tmux-config"

ln -s "`pwd`/tmux.conf" ~/.tmux.conf

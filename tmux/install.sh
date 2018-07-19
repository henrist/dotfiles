#!/bin/bash

if [ -e ~/.tmux.conf ]; then
    echo "Tmux is already set up"
    exit
fi

echo "Setting up tmux-config"

ln -s "$(pwd)/tmux.conf" ~/.tmux.conf

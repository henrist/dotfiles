#!/bin/bash

if [ -e ~/.tmux.conf ]; then
    printf "~/.tmux.conf already exists\n"
    exit 0
fi

printf "Linking tmux config\n"
ln -s "$(pwd)/tmux.conf" ~/.tmux.conf

#!/bin/bash

if [ -e ~/.tmux.conf ]; then
    echo "Tmux is already set up"
    exit
fi

echo "Setting up tmux-config"

file=tmux.conf
if test $(echo "$(tmux -V | cut -d " " -f2 | tr -d -c '[0-9.]') >= 2.9" | bc) -eq 1; then
  file=tmux-2.9.conf
fi

ln -s "$(pwd)/$file" ~/.tmux.conf

#!/bin/bash
set -eu

if [ -h ~/.gnupg/gpg-agent.conf ]; then
    echo "gpg-agent.conf is already set up"
elif [ -e ~/.gnupg/gpg-agent.conf ]; then
    echo "gpg-agent.conf already exists but is not a symlink"
else
    ln -s "$(pwd)/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
    echo "gpg-agent.conf has been set up"
fi

#!/bin/bash
. $(dirname $0)/../include.sh

if [ -e ~/.bashrc ] && grep -q "myconfig/bash" ~/.bashrc; then
    echo "Bash is already set up"
    exit 2
fi

echo ". ~/myconfig/bash/bashrc" >>~/.bashrc
echo "Bash has been set up"

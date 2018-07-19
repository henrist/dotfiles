#!/bin/bash
set -eu

setup() {(
    echo
    echo "-- $1 --"
    cd $1
    ./install.sh
)}

setup bash
setup git
setup gnupg
setup keys
setup tmux
setup vim

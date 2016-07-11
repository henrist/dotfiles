#!/bin/bash

setup() {
    (cd $1 && ./install.sh)
}

setup bash
setup git
setup keys
setup tmux
setup vim

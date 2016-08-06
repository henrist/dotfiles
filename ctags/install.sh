#!/bin/bash
. $(dirname $0)/../include.sh

if [ -e ~/.ctags ]; then
    info "ctags is already set up"
else
    ln -s ~/dotfiles/ctags/ctags ~/.ctags
    sudo apt-get install ctags
    info "ctags has been set up"
fi

#!/bin/bash
. $(dirname $0)/../include.sh

if [ -e ~/.bashrc ]; then
    echo "Vim is already set up"
    exit 2
fi

echo "Setting up vim-config"

VIMRC="$(pwd)/vimrc"

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim -u $VIMRC +PluginInstall +qall

ln -s $VIMRC ~/.vimrc

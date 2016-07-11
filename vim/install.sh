#!/bin/bash
. $(dirname $0)/../include.sh

VIMRC="$(pwd)/vimrc"

if [ -e ~/.vimrc ]; then
    echo "Vim is already set up, trying to upgrade"

    cd ~/.vim/bundle/Vundle.vim
    git pull
else
    echo "Setting up vim-config"

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim -u $VIMRC +PluginInstall +qall

if ! [ -e ~/.vimrc ]; then
    ln -s $VIMRC ~/.vimrc
fi

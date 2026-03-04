#!/bin/bash
set -eu

VIMRC="$(pwd)/vimrc"
AUTOLOAD_DIR="$HOME/.vim/autoload"
PLUG_VIM="$AUTOLOAD_DIR/plug.vim"

if [ -e ~/.vimrc ]; then
    echo "Vim is already set up, trying to upgrade"
else
    echo "Setting up vim-config"
fi

if ! [ -e "$PLUG_VIM" ]; then
    mkdir -p "$AUTOLOAD_DIR"
    if command -v curl >/dev/null 2>&1; then
        curl -fLo "$PLUG_VIM" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        wget -qO "$PLUG_VIM" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
fi

vim -u "$VIMRC" +PlugInstall +qall

if ! [ -e ~/.vimrc ]; then
    ln -s "$VIMRC" ~/.vimrc
fi

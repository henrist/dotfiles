#!/bin/bash

IDE="$(pwd)/ide.vim"
CORE="$(pwd)/core.vim"
VIMRC="$(pwd)/vimrc"

echo "source $IDE" > $VIMRC
echo "source $CORE" >> $VIMRC

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim -u $VIMRC +PluginInstall +qall

ln -s $VIMRC ~/.vimrc


#!/bin/bash
. $(dirname $0)/../include.sh

if [ -e ~/.bashrc ] && grep -q "myconfig/bash" ~/.bashrc; then
    info "bashrc is already set up"
else
    echo ". ~/myconfig/bash/bashrc" >>~/.bashrc
    info "bashrc has been set up"
fi

# (the following should be available through git bash competion)
#GIT_PROMPT=~/myconfig/bash/git-prompt.sh
#if ! [ -e $GIT_PROMPT ]; then
#    wget -qO $GIT_PROMPT https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
#    info "fetched git-prompt.sh from github"
#fi

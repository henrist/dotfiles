""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       PLUGIN INITIALIZATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Run :PlugInstall to install these

set nocompatible
filetype off
call plug#begin('~/.vim/plugged')

"Color schemes
Plug 'tomasr/molokai'

"Awesomeness from Tim Pope
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'

Plug 'craigemery/vim-autotag'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'

call plug#end()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       PLUGIN CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType java let b:dispatch = 'javac %'
autocmd FileType tex let b:dispatch = 'pdflatex % -file-line-error'

autocmd FileType tex set commentstring=\%%s
runtime! ftplugin/man.vim

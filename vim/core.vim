"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                    Behavior
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Enable listchars
set list

if has('mouse')
  set mouse=a
endif

"Allow switching between unsaved buffers
set hidden

" (i) Enable visualbell instead of beeping.
" (ii) Set type of visualbell to no type - ie. disable all bells completely.
set visualbell t_vb=

" I disable backup as I think it litters up my directories. Best practice
" dictates that I should use version control anyway.
set nobackup

" Disable swap files, for the same reasons stated w.r.t backup files.
set noswapfile

" Tell Vim to automaticaly read in changes happening to the file from outside
set autoread

" Don't override newline settings if a file uses mac-style newlines
set fileformats+=mac

" Show the mode I'm currently in
set showmode

" Padd the cursor with some lines to give the current line context
set scrolloff=3

"If browsing a line vertically: let there be a padding around the cursor
"of at least five columns.
set sidescrolloff=5

" Insert a single space rather than two after a '.', '?' and 'I' when " joining
" lines
set nojoinspaces

" Include as much as possible of the last line of the file - do not simply
" relace it with '@'-lines
set display+=lastline

" This will probably be set automatically in most terminals,
" but I set it explicitly because it is applicable to all terminals I'm likely
" to work with
set ttyfast

if exists("&wildmenu")
    "First complete till longest common string. If more than one match, list
    "all matches."
    set wildmode=longest,list
    set wildignore+=*.DS_Store " OSX metadata
    set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
    set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.tiff " binary images
    set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
    set wildignore+=*.pyc " Python byte code
    set wildignore+=*.spl " compiled spelling word lists
    set wildignore+=*.sw? " Vim swap files
endif

" Use case insensitive search, except when search string uses capital letters
set ignorecase
set smartcase

" Highlight search terms
set hlsearch

if has('persistent_undo')
  let &undodir = expand('~/.vim/backups//')
  if !isdirectory(expand('~/.vim/backups'))
    call mkdir(expand('~/.vim/backups'), 'p', 0700)
  endif
  set undofile
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set termguicolors
let g:ayucolor = 'dark'
silent! colorscheme ayu

set colorcolumn=81,121


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       Formatting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent
autocmd FileType make setlocal noexpandtab


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ","
let maplocalleader = ";"

" Make it easier to edit and source .vimrc on the fly
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Make it easier to edit and source the local configurations on the fly
nnoremap <leader>el :vsplit ~/.vimrc.local<cr>
nnoremap <leader>sl :source ~/.vimrc.local<cr>

" Make it easier to close windows and buffers
nnoremap <leader>c :bd<cr>
nnoremap <localleader>c :close<cr>
nnoremap <leader>C :bd!<cr>

"Make it easier to open a new window
nnoremap <leader>n :new<cr>

"Make it easier to follow links when reading help
nnoremap <leader><cr> <c-]>

"More intuitive movement
nnoremap H 0
nnoremap L $

nnoremap <c-p> :FZF<cr>

nnoremap \ct :!ctags -R .<cr><cr>

"Map jk to Escape for easier mode switching"
inoremap jk <esc>

" Extremely crude mappings for timestamps.
nnoremap <leader>t o<Esc>"=strftime("%Y, Week %V, %A %B %d at %X %Z: ")<C-M>pA
nnoremap <leader>T O<Esc>"=strftime("%Y, Week %V, %A %B %d at %X %Z: ")<C-M>pA

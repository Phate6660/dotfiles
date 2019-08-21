"source defaults
source $VIMRUNTIME/defaults.vim

"set search thing
set incsearch

"enable syntax highlighting
syntax enable

"set tab width to 4 spaces
set tabstop=4

"set colorscheme to delek
colorscheme delek

"for pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

"for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"for line numbers
set number norelativenumber

"enable mouse support
set mouse=a

"more natural splits
set splitbelow
set splitright

"status line
set laststatus=2
set statusline=\ \[%F\]\ %y\ %m
set statusline+=%=
set statusline+=\[%p%%\]\ \[%c\:%l\]\ 

"autoformat
noremap <F3> :Autoformat<CR>

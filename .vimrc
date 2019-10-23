" source defaults
source $VIMRUNTIME/defaults.vim

" for pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

" various settings
set number norelativenumber " relative line numbers
set mouse=a                 " enable mouse support
set cursorline              " underline current line
set showcmd                 " show command in bottom bar
set hlsearch                " highlight search matches
syntax enable               " enable syntax highlighting
colorscheme delek           " set colorscheme to delek

" more natural splits
set splitbelow
set splitright

" set tab width and indentation to 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" status line
set laststatus=2                       " display status line
set statusline=\ \[%F\]\ %y\ %m        " [file] [filetype] [modified]
set statusline+=%=                     " switch to right of status line
set statusline+=\[%p%%\]\ \[%c\:%l\]\  " [percentage] [column:line]

" for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=5

" nerdcommenter
filetype plugin on
let g:NERDSpaceDelims = 1             " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1         " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'       " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDCommentEmptyLines = 1       " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1  " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1     " Enable NERDCommenterToggle to check all selected lines is commented or not

" autoformat
noremap <F3> :Autoformat<CR>

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" keybindings to change
nnoremap <C-A> ^
nnoremap <C-E> $

" keybindings to disable
nnoremap ^ <nop>
nnoremap $ <nop>

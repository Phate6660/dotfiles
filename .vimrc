" source defaults
source $VIMRUNTIME/defaults.vim

" various settings
set number relativenumber   " relative line numbers
set mouse=a                 " enable mouse support
set cursorline              " underline current line
set showcmd                 " show command in bottom bar
set hlsearch                " highlight search matches
syntax enable               " enable syntax highlighting

" more natural splits
set splitbelow
set splitright

" set tab width and indentation to 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" autoformat
noremap <F3> :Autoformat<CR>

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

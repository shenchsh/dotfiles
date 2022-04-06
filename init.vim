set background=dark

let mapleader=','

set showmatch               " show matching 
set ignorecase              " case insensitive 
set hlsearch                " highlight search 
set incsearch               " incremental search
set scrolloff=5
set cursorline
set relativenumber 

set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
set ttyfast                 " Speed up scrolling in Vim

set autoindent    
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents

call plug#begin('~/.nvim/plugged')
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'junegunn/fzf', {'dir': '~/dotfiles/zsh/fzf'}

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()

autocmd vimenter * ++nested colorscheme gruvbox
lua require'lspconfig'.rust_analyzer.setup({})

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

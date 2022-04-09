" vim-plug: https://github.com/junegunn/vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

let mapleader="\<Space>"

if (has("termguicolors"))
    set termguicolors
endif

set background=dark
syntax enable

filetype plugin indent on
set autoindent

set cursorline
set relativenumber
set mouse=a
set scrolloff=5
set expandtab
set tabstop=4
set shiftwidth=4
set hlsearch
set showmatch
set clipboard+=unnamedplus

set modifiable
set nocompatible

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

call plug#begin('~/.vim/plugged')
Plug 'neovim/nvim-lspconfig'

" Completion framework
Plug 'hrsh7th/nvim-cmp'
" LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
" Snippets source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip'
" Snippets plugin
Plug 'L3MON4D3/LuaSnip'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
" {{{
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
" }}}

Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
" {{{
" Disable default mappings
let g:EasyMotion_do_mapping = 0

nmap s <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" }}}

Plug 'tmsvg/pear-tree'
Plug 'scrooloose/nerdtree'
" {{{
let g:NERDTreeMinimalUI = 1
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeWinSize = 31
let g:NERDTreeChDirMode = 2
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeCascadeOpenSingleChildDir = 1

map <F1> :call NERDTreeToggleAndFind()<cr>
map <F2> :NERDTreeToggle<CR>

function! NERDTreeToggleAndFind()
    if (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
        execute ':NERDTreeClose'
    else
        execute ':NERDTreeFind'
    endif
endfunction
" }}}

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" {{{
let g:fzf_nvim_statusline = 0 " disable statusline overwriting
nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>A :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
nnoremap <silent> <leader>. :AgIn

nnoremap <silent> K :call SearchWordWithAg()<CR>
vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>
nnoremap <silent> <leader>ft :Filetypes<CR>

imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)
" }}}

" Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
" {{{
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_italic_comment = 1
" }}}
call plug#end()


lua <<EOF
require("trouble").setup {}

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
-- map after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local servers = { 'rls' }
for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150,
            }
        }
end

local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
        require('luasnip').lsp_expand(args.body)
    end,
    },
mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
        },
    ['<Tab>'] = function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    else
        fallback()
    end
end,
['<S-Tab>'] = function(fallback)
if cmp.visible() then
    cmp.select_prev_item()
elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
else
    fallback()
end
    end,
    },
sources = {
    { name = 'nvim_lsp' },
    },
}
EOF

colorscheme gruvbox-material
let g:lightline = {'colorscheme' : 'gruvbox_material'}

-- disable netrw at the very start of your init.lua (strongly advised)
-- netrw is a standard neovim plugin that is enabled by default. It provides,
-- amongst other functionality, a file/directory browser.
-- It interferes with nvim-tree and the intended user experience is nvim-tree
-- replacing the |netrw| browser.

if vim.fn.has('nvim-0.12') == 0 then
  error('This configuration requires Neovim 0.12+. On macOS: brew upgrade neovim')
end

-- Resolve the dotfiles directory even when init.lua is individually symlinked.
local config_dir = vim.fn.fnamemodify(vim.fn.resolve(debug.getinfo(1, 'S').source:sub(2)), ':h')
vim.opt.rtp:prepend(config_dir)
vim.g.dotfiles_nvim_dir = config_dir

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('options')
require('mappings')
require('plugins')

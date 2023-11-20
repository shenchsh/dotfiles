-- disable netrw at the very start of your init.lua (strongly advised)
-- netrw is a standard neovim plugin that is enabled by default. It provides,
-- amongst other functionality, a file/directory browser.
-- It interferes with nvim-tree and the intended user experience is nvim-tree
-- replacing the |netrw| browser.

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('options')
require('mappings')
require('plugins')

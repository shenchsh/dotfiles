-- set leader to <Space>
-- https://www.reddit.com/r/vim/wiki/the_leader_mechanism/
vim.api.nvim_set_keymap(
  "",
  "<Space>",
  "<Nop>",
  { noremap = true, silent = true }
)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

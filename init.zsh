#!/bin/zsh

top_level_dotfiles=(
    ".zshenv"
    ".tmux.conf"
)

for f in ${top_level_dotfiles[*]}; do
    ln -sf ~/dotfiles/"$f" ~/"$f"
done

nvim_config=(
  "local.lua"
  "lsp.lua"
  "mappings.lua"
  "options.lua"
  "plugins.lua"
)

mkdir -p ~/.config/nvim/lua
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
for f in ${nvim_config[*]}; do 
  ln -sf ~/dotfiles/nvim/lua/"$f" ~/.config/nvim/lua/"$f"
done

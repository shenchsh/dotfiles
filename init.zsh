#!/bin/zsh

top_level_dotfiles=(
    ".zshenv"
    ".tmux.conf"
)

for f in ${top_level_dotfiles[*]}; do
    ln -sf ~/dotfiles/"$f" ~/"$f"
done

cp -s -r ~/dotfiles/nvim ~/.config/
cp -s -r ~/dotfiles/wezterm ~/.config/

#!/bin/zsh

top_level_dotfiles=(
    ".zshenv"
    ".vimrc"
    ".tmux.conf"
)

for f in ${top_level_dotfiles[*]}; do
    ln -sf ~/dotfiles/"$f" ~/"$f"
done

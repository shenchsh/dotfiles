#!/bin/zsh

top_level_dotfiles=(
    ".zshenv"
#    ".tmux.conf"
)

for f in ${top_level_dotfiles[*]}; do
    ln -sf ~/dotfiles/"$f" ~/"$f"
done

cp -s -r ~/dotfiles/nvim ~/.config/

mkdir -p ~/.codex
ln -sf ~/dotfiles/agent/AGENTS.md ~/.codex/AGENTS.md

# git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote

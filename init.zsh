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

# iTerm2 reads the shared preferences, including color presets, at startup.
if [[ "$(uname -s)" == Darwin ]]; then
    mkdir -p "$HOME/Library/Fonts" || exit 1
    for font in "$HOME/dotfiles/third-party/fonts/JetBrainsMono/"*.ttf; do
        if ! cmp -s "$font" "$HOME/Library/Fonts/${font:t}"; then
            install -m 644 "$font" "$HOME/Library/Fonts/${font:t}" || exit 1
        fi
    done

    plutil -lint "$HOME/dotfiles/iTerm2/com.googlecode.iterm2.plist" >/dev/null || exit 1
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/dotfiles/iTerm2" || exit 1
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true || exit 1
    # Keep device-local changes from overwriting the tracked preferences.
    defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true || exit 1
    defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 1 || exit 1
    print "iTerm2 will load dotfiles settings on its next launch. Restart it when your sessions are ready."
fi

# Starship and zoxide run directly from third-party/bin via zsh/.zshrc.

# git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote

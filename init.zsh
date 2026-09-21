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

# Install the bundled version so pulling updates also updates the prompt offline.
(
    case "$(uname -s)-$(uname -m)" in
        Darwin-arm64) starship_target=aarch64-apple-darwin ;;
        Darwin-x86_64) starship_target=x86_64-apple-darwin ;;
        Linux-aarch64|Linux-arm64) starship_target=aarch64-unknown-linux-musl ;;
        Linux-x86_64) starship_target=x86_64-unknown-linux-musl ;;
        *) print -u2 "Skipping Starship: no bundled binary for this platform."; exit 0 ;;
    esac

    starship_archive="$HOME/dotfiles/third-party/starship/starship-$starship_target.tar.gz"
    if [[ ! -r "$starship_archive" ]]; then
        print -u2 "Missing bundled Starship archive: $starship_archive"
        exit 1
    fi

    mkdir -p "$HOME/bin" || exit 1
    starship_temp=$(mktemp -d "$HOME/bin/.starship.XXXXXX") || exit 1
    trap 'rm -rf "$starship_temp"' EXIT
    tar -xzf "$starship_archive" -C "$starship_temp" starship || exit 1
    chmod 755 "$starship_temp/starship" || exit 1
    if [[ ! -x "$HOME/bin/starship" ]] || ! cmp -s "$starship_temp/starship" "$HOME/bin/starship"; then
        mv -f "$starship_temp/starship" "$HOME/bin/starship" || exit 1
    fi
) || exit 1

# git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote

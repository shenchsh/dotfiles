# Interactive Zsh configuration. ZDOTDIR and the cache directory are set in .zshenv.

# --- Completions ---

autoload -Uz compinit
compinit -d "${ZSH_CACHE_DIR}/zcompdump-$ZSH_VERSION"

# --- PATH and platform integration ---

path=(
  "$HOME/bin"
  "$HOME/dotfiles/bin"
  "$HOME/.cargo/bin"
  "${path[@]}"
)

if [[ -r "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  path=(
    "$HOME/dotfiles/bin/linux"
    "${path[@]}"
  )
elif [[ "$OSTYPE" == "darwin"* ]]; then
  path=(
    "$HOME/dotfiles/bin/macos"
    "$HOME/homebrew/bin"
    "$HOME/homebrew/opt/riscv-gnu-toolchain/bin"
    "$HOME/homebrew/opt/gnu-sed/libexec/gnubin"
    "$HOME/homebrew/opt/qemu/bin"
    /opt/homebrew/bin
    "${path[@]}"
  )

  if [[ -r "$HOME/.iterm2_shell_integration.zsh" ]]; then
    source "$HOME/.iterm2_shell_integration.zsh"
  fi
else
  echo "Unsupported operating system"
  exit 1
fi

# --- Plugins (listed in .zsh_plugins.txt) ---

source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
antidote load

# --- Fuzzy completion and key bindings ---

export FZF_BASE="$HOME/dotfiles/zsh/.fzf"
if [[ -r "$FZF_BASE/completion.zsh" ]]; then
  source "$FZF_BASE/completion.zsh"
fi

# Load fzf bindings after zsh-vi-mode so they aren't overwritten.
function init_fzf_key_bindings() {
  if [[ -r "$FZF_BASE/key-bindings.zsh" ]]; then
    source "$FZF_BASE/key-bindings.zsh"
  fi
}
zvm_after_init_commands+=(init_fzf_key_bindings)

# --- History ---

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=500000

# Expansion and persistence.
setopt BANG_HIST                # Enable ! history expansion.
setopt EXTENDED_HISTORY         # Save timestamps and command durations.
setopt INC_APPEND_HISTORY       # Append commands as they are entered.
setopt SHARE_HISTORY            # Share history across sessions.

# Keep history compact and avoid repeated search results.
setopt HIST_EXPIRE_DUPS_FIRST   # Remove duplicates first when trimming history.
setopt HIST_IGNORE_DUPS         # Skip consecutive duplicates.
setopt HIST_IGNORE_ALL_DUPS     # Remove older copies of repeated commands.
setopt HIST_FIND_NO_DUPS        # Skip duplicates when searching history.
setopt HIST_SAVE_NO_DUPS        # Omit older duplicates when saving history.
setopt HIST_REDUCE_BLANKS       # Remove unnecessary whitespace.
setopt HIST_VERIFY              # Let expanded history commands be edited first.

# --- Helpers and aliases ---

function mkcd() {
  mkdir -p "$1" && cd "$1"
}

alias s=ssh
alias vim=nvim

# --- Private local settings ---

if [[ -r "$HOME/dotfiles/zsh/.zsensitive" ]]; then
  source "$HOME/dotfiles/zsh/.zsensitive"
fi

# --- Language tools and application integrations ---

# Node.js version manager.
export NVM_DIR="$HOME/.nvm"
if [[ -r "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi

# OpenClaw command completion.
if [[ -r "$HOME/.openclaw/completions/openclaw.zsh" ]]; then
  source "$HOME/.openclaw/completions/openclaw.zsh"
fi

# BEGIN opam configuration
# OCaml environment and completion; suppress startup output.
if [[ -r "$HOME/.opam/opam-init/init.zsh" ]]; then
  source "$HOME/.opam/opam-init/init.zsh" >/dev/null 2>&1
fi
# END opam configuration

# OrbStack command-line tools; tolerate missing or failed initialization.
if [[ -r "$HOME/.orbstack/shell/init.zsh" ]]; then
  source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
fi

# --- Prompt ---

# Initialize the prompt after PATH, plugins, and shell integrations are ready.
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

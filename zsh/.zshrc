# Login shell: echo $0 outputs '-'

# /etc/zshenv
# ${ZDOTDIR:-$HOME}/.zshenv
#   Always sourced. Define $PATH, $EDITOR, $PAGER, $ZDOTDIR etc
#
# /etc/zprofile
# ${ZDOTDIR:-$HOME}/.zprofile
#
# /etc/zshrc
# ${ZDOTDIR:-$HOME}/.zshrc (for interactive shell)
#
# /etc/zlogin
# ${ZDOTDIR:-$HOME}/.zlogin
#
# ${ZDOTDIR:-$HOME}/.zlogout
# /etc/zlogout


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit
compinit -d "${ZSH_CACHE_DIR}/zcompdump-$ZSH_VERSION"

################################
# Platform-dependent configs
################################
path=(
  $HOME/bin
  $HOME/dotfiles/bin
  $HOME/.cargo/bin
  $path
)

[[ -s $HOME/.cargo/env ]] && source $HOME/.cargo/env

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  path=(
    $HOME/dotfiles/bin/linux
    $path
  )
elif [[ "$OSTYPE" == "darwin"* ]]; then
  path=(
    $HOME/dotfiles/bin/macos
    $HOME/homebrew/bin
    $HOME/homebrew/opt/riscv-gnu-toolchain/bin
    $HOME/homebrew/opt/gnu-sed/libexec/gnubin
    $HOME/homebrew/opt/qemu/bin
    /opt/homebrew/bin
    $path
  )
else
  echo "Unsupported operating system"
  exit 1
fi

################################
# Plugins
################################
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load

[[ -s ${ZDOTDIR:-$HOME}/.p10k.zsh ]] && source ${ZDOTDIR:-$HOME}/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

export FZF_BASE=$HOME/dotfiles/zsh/.fzf
[[ -s ${FZF_BASE}/completion.zsh ]] && source ${FZF_BASE}/completion.zsh

# Prevent overwriting fzf key-bindings
function init_fzf_key_bindings() {
  [[ -s ${FZF_BASE}/key-bindings.zsh ]] && source ${FZF_BASE}/key-bindings.zsh
}
zvm_after_init_commands+=(init_fzf_key_bindings)


################################
# Customization
################################
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=500000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

function mkcd() {
  mkdir -p "$1" && cd "$1"
}

alias s=ssh
alias vim=nvim

[[ -s $HOME/dotfiles/zsh/.zsensitive ]] && source $HOME/dotfiles/zsh/.zsensitive

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

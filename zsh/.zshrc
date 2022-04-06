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

################################
# Platform-dependent configs
################################
path=(
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
        $path
    )
else
    echo "Unsupported operating system"
    exit 1
fi

HOSTNAME=$(hostname)
if [[ "$HOSTNAME" =~ "devvm" || "$HOSTNAME" =~ "devbig" ]]; then
    is_dev=1
elif [[ "$HOSTNAME" =~ "od" ]]; then
    is_od=1
fi

if [[ $is_dev || $is_od ]]; then
    [[ -z "$LOCAL_ADMIN_SCRIPTS" ]] && export LOCAL_ADMIN_SCRIPTS='/usr/facebook/ops/rc'
    source "${LOCAL_ADMIN_SCRIPTS}/master.zshrc"
    source "${LOCAL_ADMIN_SCRIPTS}/scm-prompt"
fi

################################
# Plugins
################################
source ${ZDOTDIR:-$HOME}/.antigen.zsh

antigen use oh-my-zsh

# acs, or acs <keyword>
antigen bundle aliases
antigen bundle brew
antigen bundle colored-man-pages
antigen bundle command-not-found
# .envrc, direnv allow . 
antigen bundle direnv
antigen bundle dnf
# extract <filename>
antigen bundle extract
antigen bundle fasd
antigen bundle git
antigen bundle mercurial
antigen bundle ripgrep
antigen bundle rust
antigen bundle systemd
antigen bundle tmux
antigen bundle jeffreytse/zsh-vi-mode

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k

antigen apply

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

function _diff_hg() {
    if [[ -z $1 ]]; then
        hg diff -r '.^'
    else
        x=$(hg book | grep -e "$1 ")
        hg diff -c ${x: -12}
    fi
}

function mkcd() {
    mkdir -p "$1" && cd "$1"
}

function upload() {
    rsync -azvhP $2 root@"$1":/tmp/$(basename "$2")
}

function download() {
    rsync -azvhP root@"$1":"$2" /tmp/$(basename "$2")
}

alias dhg=_diff_hg
alias hs='noglob hostselect'
alias s=ssh
alias odc='ondemand-admin canary'
alias vim=nvim

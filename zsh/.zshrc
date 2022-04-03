# Login shell: echo $0 outputs '-'

# /etc/zshenv
# ${ZDOTDIR:-$HOME}/.zshenv
#   Always sourced. Define $PATH, $EDITOR, $PAGER, $ZDOTDIR etc
#
# /etc/zprofile
# ${ZDOTDIR:-$HOME}/.zprofile (for login shell)
#
# /etc/zshrc
# ${ZDOTDIR:-$HOME}/.zshrc (for interactive shell)
#
# /etc/zlogin
# ${ZDOTDIR:-$HOME}/.zlogin (for login shell)
#
# ${ZDOTDIR:-$HOME}/.zlogout (for login shell)
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
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    path=(
        ~/dotfiles/bin/linux
        $path
    )
elif [[ "$OSTYPE" == "darwin"* ]]; then
    path=(
        ~/dotfiles/bin/macos
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

alias dbg=_diff_hg
alias hs='noglob hostselect'
alias s=ssh
alias odc='ondemand-admin canary'

################################
# Plugins
################################
source $ZDOTDIR/.antigen.zsh

export FZF_BASE=~/dotfiles/zsh/fzf

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
antigen bundle fzf
antigen bundle git
antigen bundle mercurial
antigen bundle ripgrep
antigen bundle rust
antigen bundle systemd
antigen bundle tmux

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme romkatv/powerlevel10k

antigen apply

# vi-mode plugin conflicts with fzf, use raw binding intead
bindkey -v

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

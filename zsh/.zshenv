[[ -s "${ZDOTDIR:-$HOME}/.zprofile" ]] && source "${ZDOTDIR:-$HOME}/.zprofile"

[[ -z "${ZSH_CACHE_DIR}" ]] && ZSH_CACHE_DIR="$HOME/.cache/zsh"
[[ ! -d "${ZSH_CACHE_DIR}" ]] && mkdir "${ZSH_CACHE_DIR}"

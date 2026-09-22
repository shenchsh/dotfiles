# Shared by .zprofile and .zshrc; safe to source more than once.
typeset -gU cdpath fpath mailpath path

case "$OSTYPE" in
  darwin*) typeset -g DOTFILES_OS=macos ;;
  linux*) typeset -g DOTFILES_OS=linux ;;
  *) typeset -g DOTFILES_OS=unknown ;;
esac

case "$(uname -m)" in
  x86_64|amd64) typeset -g DOTFILES_ARCH=x86_64 ;;
  aarch64|arm64) typeset -g DOTFILES_ARCH=aarch64 ;;
  i[3-6]86|x86) typeset -g DOTFILES_ARCH=x86 ;;
  arm|armv[5-8]*|armhf|armel) typeset -g DOTFILES_ARCH=arm ;;
  *) typeset -g DOTFILES_ARCH=unknown ;;
esac

typeset -g DOTFILES_TARGET=''
case "$DOTFILES_OS:$DOTFILES_ARCH" in
  macos:aarch64|macos:x86_64) DOTFILES_TARGET="$DOTFILES_ARCH-apple-darwin" ;;
  linux:aarch64|linux:x86_64) DOTFILES_TARGET="$DOTFILES_ARCH-unknown-linux-musl" ;;
esac

# Keep temporary variables local to this anonymous function.
() {
  local brew_prefix entry
  local -a candidates brew_prefixes

  if [[ -n "$DOTFILES_TARGET" ]]; then
    candidates+=("$HOME/dotfiles/third-party/bin/$DOTFILES_TARGET")
  fi

  candidates+=("$HOME/bin" "$HOME/dotfiles/third-party/bin" "$HOME/.local/bin" "$HOME/.cargo/bin")
  case "$DOTFILES_OS:$DOTFILES_ARCH" in
    macos:aarch64) brew_prefix=/opt/homebrew ;;
    macos:x86_64) brew_prefix=/usr/local ;;
  esac
  if [[ "$DOTFILES_OS" == macos ]]; then
    # Preserve support for the user's custom Homebrew installation.
    brew_prefixes=("$HOME/homebrew")
    [[ -n "$brew_prefix" ]] && brew_prefixes+=("$brew_prefix")
    for entry in "${brew_prefixes[@]}"; do
      candidates+=("$entry/bin" "$entry/sbin")
      candidates+=("$entry/opt/riscv-gnu-toolchain/bin"
                   "$entry/opt/gnu-sed/libexec/gnubin" "$entry/opt/qemu/bin")
    done
  fi
  candidates+=(/usr/local/bin /usr/local/sbin)

  # Do not add nonexistent directories; preserve the inherited system PATH.
  local -a existing
  for entry in "${candidates[@]}"; do
    [[ -d "$entry" ]] && existing+=("$entry")
  done
  path=("${existing[@]}" "${path[@]}")
}

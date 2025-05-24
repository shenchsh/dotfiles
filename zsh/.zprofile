#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

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

#
# Editors
#
if command -v nvim &> /dev/null
then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

export PAGER='less'

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X to enable it.
export LESS='-g -i -M -R -S -w -X -z-4'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

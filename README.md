# dotfiles

## Installation

```
git clone --recurse-submodules https://github.com/shenchsh/dotfiles.git
./init.zsh
```

Keep the checkout at `~/dotfiles`. Setup links configuration and installs the
bundled Starship prompt into `~/bin` without downloading it. Starship binaries
support macOS and Linux on ARM64 and x86-64.

To apply updates, run `git pull` followed by `zsh init.zsh` from `~/dotfiles`.
Open a new shell to load the updated configuration.

# dotfiles

## Installation

```
git clone --recurse-submodules https://github.com/shenchsh/dotfiles.git
./init.zsh
```

Keep the checkout at `~/dotfiles`. Setup links configuration. Zsh selects bundled Starship, zoxide, and fzf binaries
from `third-party/bin/<target>` for macOS and Linux on ARM64 and x86-64.
No download or binary installation is needed. This directory takes precedence
over `~/bin` and package-manager paths. Use `z` to jump to a visited directory
or `zi` to select one with fzf.

To apply updates, run `git pull` followed by `zsh init.zsh` from `~/dotfiles`.
Open a new shell to load the updated configuration.

Shell platform detection and PATH setup live in `zsh/platform.zsh`, shared by
`.zprofile` and `.zshrc`. It recognizes macOS and Linux, normalizes `amd64` /
`x86_64` and `arm64` / `aarch64`, and distinguishes 32-bit x86 and ARM.
Bundled Starship, zoxide, and fzf support only the four 64-bit targets above; other
architectures use installed tools from PATH. The shared `third-party/bin` directory
is also on PATH. Homebrew paths are added only on macOS, missing
directories are skipped, and repeated sourcing does not duplicate PATH entries.
Unknown platforms retain a usable shell without bundled binaries.

On macOS, setup installs the bundled JetBrains Mono Nerd Font Mono into
`~/Library/Fonts` and points iTerm2 to the shared preferences in `iTerm2/`.
Restart iTerm2 when your sessions are ready to load them. Theme source files live
in `third-party/iterm2/`; their presets are already included in the preferences.

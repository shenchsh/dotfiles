# Zsh completions

`_zoxide` is the unmodified completion from the official zoxide v0.10.0 release,
matching the bundled binaries. Its license is in
`../../third-party/bin/LICENSE.zoxide`. Update it alongside the zoxide binaries
using `completions/_zoxide` from the verified release archive.

`.zshrc` adds this directory to `fpath` before `compinit`, enabling completion
for `zoxide` subcommands and options. `zoxide init zsh` separately registers the
native completion for `z`: use `z <Tab>` for local directories or type
`z query ` (including the trailing space) and press Tab for the fzf picker.
`zi query` also opens interactive directory selection.

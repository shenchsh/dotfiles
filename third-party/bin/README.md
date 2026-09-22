# Bundled command-line tools

These executable files run directly from the checkout, without installation:

- Starship **v1.26.0**: https://github.com/starship/starship/releases/tag/v1.26.0
- fzf **v0.74.4**: https://github.com/junegunn/fzf/releases/tag/v0.74.4
- zoxide **v0.10.0**: https://github.com/ajeetdsouza/zoxide/releases/tag/v0.10.0

| Directory | Platform |
| --- | --- |
| `aarch64-apple-darwin` | macOS ARM64 |
| `x86_64-apple-darwin` | macOS Intel |
| `aarch64-unknown-linux-musl` | Linux ARM64 |
| `x86_64-unknown-linux-musl` | Linux x86-64 |

`zsh/platform.zsh`, sourced by `.zprofile` and `.zshrc`, detects the operating
system and architecture and prepends the matching directory to PATH. `.zshrc`
initializes Starship and zoxide and loads fzf shell bindings. All three binaries
are bundled for every target above. Linux uses musl builds for Starship and
zoxide and static Linux builds for fzf.
The shared `third-party/bin` directory is also on PATH. Unmatched architectures
receive only the shared directory and can use installed tools from PATH.

Run `git pull` followed by `zsh init.zsh`, then open a new shell to apply updates.
Setup no longer extracts Starship into `~/bin`. Any previous copy is preserved;
the bundled directory precedes it in PATH.

To update a tool, download all four archives from one official release and
verify their SHA-256 hashes against GitHub release metadata. Extract only the
tool executable into each target directory and preserve executable permissions.
Update its version here, upstream license, `ARCHIVE_SHA256SUMS` (source archive
hashes), and `SHA256SUMS` (extracted binary hashes). Commit the binaries and
metadata together so devices can update offline after pulling.

Verify the executables from this directory with `shasum -a 256 -c SHA256SUMS`
(or `sha256sum -c SHA256SUMS` on Linux).

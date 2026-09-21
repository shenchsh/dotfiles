# Starship binaries

Pinned version: **v1.26.0** from the
[official release](https://github.com/starship/starship/releases/tag/v1.26.0).

The release archives cover macOS and Linux on ARM64 and x86-64. Linux uses
the musl builds. `init.zsh` extracts the matching binary into `$HOME/bin`;
installation requires no network, Rust toolchain, or package manager.
The existing `zsh/.zshrc` adds that directory to PATH and initializes Starship.
Unsupported platforms are skipped with a message.

`SHA256SUMS` records archive hashes verified against GitHub release metadata.
`LICENSE` is the upstream license for this version.

To update, replace all four archives from one official release, verify their
SHA-256 hashes against its release metadata, update `SHA256SUMS`, the license,
and the version above. Keep archive filenames unchanged so `init.zsh` continues
to select them. Commit the archives with the metadata so other devices receive
them through `git pull`.

Verify archives from this directory with `shasum -a 256 -c SHA256SUMS`
(or `sha256sum -c SHA256SUMS` on Linux).

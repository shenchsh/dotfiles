# Coach

- `Coach-Mac-Setup.zip`: installable package (Apple silicon, macOS 13+).
- `config/settings.json`: shared model and instructions; API keys remain in Keychain.
- `CoachSource/`: source and resources. Rebuild with `zsh coach/CoachSource/build.sh` from the dotfiles root.

Coach reads and writes `~/dotfiles/coach/config/settings.json` when sharing is enabled. Sync the checkout between Macs through your normal dotfiles workflow, then click **Refresh** in Coach. Coach does not run Git synchronization.

The build script updates `Coach-Mac-Setup.zip` using a temporary directory and removes the unpacked files when finished.

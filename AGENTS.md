# dotfiles

Shared configuration for multiple devices, with macOS and Linux components.
The current setup expects the checkout at `$HOME/dotfiles`.

## Project layout

- `init.zsh`: links shell, Neovim, and global Codex configuration and installs Starship.
- `.zshenv` and `zsh/`: shell startup, environment, plugins, and prompt configuration.
- `nvim/`: Neovim options, mappings, and plugins.
- `agent/AGENTS.md`: personal instructions linked to `~/.codex/AGENTS.md`.
  Keep repository-specific guidance in this root file.
- `bin/`: shared utilities and platform-specific binaries.
- `third-party/`: bundled dependencies; Starship release archives support offline setup.
- `iTerm2/`: macOS terminal preferences, profiles, and themes.
- `remap/`: Linux keyboard remapping configuration and service.
- `coach/`: macOS English-learning app, source, and setup package;
  follow `coach/CoachSource/AGENTS.md` when changing its source.

## Cross-device configuration

- Users update a device by running `git pull` followed by `zsh init.zsh`
  from `$HOME/dotfiles`. Configuration changes must be applied automatically
  through this workflow, without additional manual copying or setup commands.
- When adding or changing configuration, update `init.zsh` or a script it calls
  whenever installation, linking, or migration is needed.
- Keep setup safe to rerun: create missing directories, refresh managed links,
  and preserve unrelated user files.
- Use `$HOME` or paths derived from the checkout, never a device-specific username
  or absolute home path. Guard platform-specific operations and optional tools.
- Keep credentials and device-local secrets out of tracked configuration.

## Validation

- After completing a change, update all affected documentation to match the
  final behavior. Use concise, clear language and remove outdated instructions.
- Check changed shell scripts with `zsh -n <file>`.
- For setup changes, verify a fresh setup and a second run using a temporary home;
  confirm the intended links and configuration are applied without manual steps.
- For configuration changes, verify the cross-device update workflow:
  `git pull` followed by `zsh init.zsh` applies the changes on each affected
  platform without manual setup. Check portability across home directories and
  that platform-specific steps are skipped where unsupported. Report any
  device or platform checks that could not be run.

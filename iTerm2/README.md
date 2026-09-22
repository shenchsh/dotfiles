# iTerm2 configuration

`com.googlecode.iterm2.plist` is the shared configuration, including the default
profile and the Catppuccin Latte and Snazzy color presets. `Default.json` is a
reference profile export; setup does not import it separately.

On macOS, `zsh init.zsh` configures iTerm2 to load preferences from this directory
at startup. Restart iTerm2 when your sessions are ready. Linux skips this step.
Setup disables automatic saving back to this directory so local changes cannot
overwrite the tracked configuration.

New split panes inherit the current pane's working directory. New tabs and
windows start in the home directory. This is configured in the default profile's
advanced initial-directory settings, in both the shared preferences and reference
export.

The profile uses JetBrains Mono Nerd Font Mono at 14 pt. Setup installs its
regular, bold, italic, and bold italic styles from `third-party/fonts/JetBrainsMono/`
into `~/Library/Fonts`, without downloading anything.

Theme source files are in `third-party/iterm2/`. When changing a shared theme,
update both its source file and its preset in `com.googlecode.iterm2.plist`.

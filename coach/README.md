# Coach

The project directory is `~/dotfiles/coach`. Make source changes here; earlier copies under `Documents/Codex` are no longer the development source.

- `CoachSource/`: current Coach 1.4.2 source and resources.
- `CoachSource/AGENTS.md`: development instructions and the English-learning input boundary.
- `Coach-Mac-Setup.zip`: installable package for Apple silicon, macOS 13+, excluding source code.
- `config/settings.json`: legacy shared-settings reference; the current app does not load it.

## Build

From `~/dotfiles/coach`, run:

```sh
zsh CoachSource/build.sh
```

The build signs and verifies the app, then updates `Coach-Mac-Setup.zip`. Temporary build files are removed automatically. Building does not replace an installed app.

## Active settings

Coach stores editable instructions in the local `com.chanson.coach` preference `customInstructions`. The default prompt and fixed input-boundary instructions are in `CoachSource/main.swift`. API keys remain in Keychain. Change the current prompt in Coach's settings; changing only the source default does not overwrite a saved custom prompt.

# Dotfiles

Tool configuration is scattered by default — each application owns its own directory. These dotfiles pull everything into a single versioned repository and symlink it back into place. Changes are reflected immediately, and provisioning a new machine is a `git clone` and `./setup.sh`.

## Conventions

- `topic/*.zsh`: Files loaded by `.zshrc` during the execution of the `install` script;
- `topic/*.symlink`: Files with `*.symlink` extension get symlinked to their respective application configuration locations;
- `topic/*.yml`: Files copied to target locations during the execution of the `install` script;
- `topic/setup.sh`: Topic-scoped setup scripts that can be run independently;

## Install

```sh
  git clone https://github.com/pedroseabra1091/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  ./setup.sh
```

The `install` script symlinks the appropriate files to your home directory which makes everything controllable via `~/.dotfiles`.

Additionally, it fine tunes the macOS dock to my preferences.

> [!TIP]
> Check [mac-defaults](https://macos-defaults.com) for further tuning of your macOS UI setup.

> [!WARNING]
A few unicode characters aren't correctly displayed on iterm2. In order to fix it, set the default font to the pre-installed `Hack Nerd Font Mono`.

> [!WARNING]
Iterm2 default key preset switches a few viable key shortcuts (e.g: `cmd+backspace`).
In order switch to a more familiar preset go to `Preferences`->`Profiles`->`Keys`, click on `Load Preset` and set to _Natural Text Editing_.

### Obsidian

Obsidian configuration can also be set up independently via its own setup script:

```sh
./obsidian/setup.sh --vault ~/path/to/your/vault
```

## Optional flags
- `--skip-dock-setup`, `-s`: Skips the setup of the macOS dock
- `--vault <path>`, `-v`: Path to an Obsidian vault — when provided, symlinks Obsidian config files into `<vault>/.obsidian/`


## References

- [Brew Bundle Brewfile Tips](https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f)

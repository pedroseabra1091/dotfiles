## Dotfiles

![dotfiles-banner](dotfiles-banner.png)

## Subdirectories explained

- `Brewfile`: Blueprint that contains all the formulaes and casks I use daily;
- `topic/*.zsh`: Files loaded by `.zshrc` during the execution of the `install` script;
- `topic/*.symlink`: Files with `*.symlink` extension get symlinked into your `$HOME` after the `install` script is executed.This is the easiest way to have all the dotfiles version controlled while still keeping them loaded in your home directory;
#!/usr/bin/env bash

source "$(dirname "$0")/lib/helpers.sh"

# Optional flags
skip_dock_setup=false
vault_path=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --skip-dock-setup | -s) skip_dock_setup=true ;;
        --vault | -v) vault_path="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ ! $(command -v brew) ]; then
  xecho_info "install" "Installing brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  xecho_info "update" "Update brew"
  brew update
fi

if uname -a | grep -q arm; then
  xecho_info "brew" "Set ARM homebrew to global PATH variable"
  export PATH="/opt/homebrew/bin:$PATH"
  export BREW_PATH="/opt/homebrew/bin"
else
  xecho_info "brew" "Set x86 homebrew to global PATH variable"
  export PATH="/usr/local/bin:$PATH"
  export BREW_PATH="/usr/local/bin"
fi

xecho_info "brew" "Bundling formulaes & casks"
brew bundle install

if [ ! -d ~/.oh-my-zsh ]; then
  xecho_info "zsh" "Install oh-my-zsh"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d ~/.powerlevel10k ]; then
  xecho_info "zsh" "Install p10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
fi

xecho_info "zsh" "Symlink p10k config"
ln -s -i $(pwd)/p10k/p10k.zsh.symlink ~/.p10k.zsh

xecho_info "zsh" "Symlink zshrc"
ln -s -i $(pwd)/zsh/zshrc.symlink ~/.zshrc
source ~/.zshrc

xecho_info "mise" "Symlink .tool-versions"
ln -s -i $(pwd)/mise/tool-versions.symlink ~/.tool-versions
(cd ~/ && mise install)

xecho_info "git" "Symlink .gitconfig"
ln -s -i $(pwd)/git/gitconfig.symlink ~/.gitconfig

if [ -f "$BREW_PATH/code" ]; then
  cat code/vscode-extensions.list | grep -v '^#' | xargs -L1 "$BREW_PATH/code" --install-extension
  xecho_info "code" "Installing extensions"
else
  xecho_error "code" "Couldn't install extensions"
fi

xecho_info "code" "Symlink keybindings.json to main profile"
ln -s -i $(pwd)/code/keybindings.json.symlink  ~/Library/Application\ Support/Code/User/keybindings.json

xecho_info "code" "Symlink settings.json to main profile"
ln -s -i $(pwd)/code/settings.json.symlink  ~/Library/Application\ Support/Code/User/settings.json

xecho_info "code" "Symlink keybindings.json to secundary profiles"
profiles=$(find ~/Library/Application\ Support/Code/User/profiles/ -mindepth 1 -maxdepth 1 -type d | awk -F 'profiles/' '{print $2}')
while IFS= read -r profile; do
  ln -s -f "$(pwd)/code/keybindings.json.symlink" "$HOME/Library/Application Support/Code/User/profiles/$profile/keybindings.json"
  ln -s -f "$(pwd)/code/settings.json.symlink" "$HOME/Library/Application Support/Code/User/profiles/$profile/settings.json"
done <<< "$profiles"

if [ -d ~/.config/karabiner ]; then
  xecho_info "karabiner" "Symlink karabiner.json"
  ln -s -i $(pwd)/karabiner/karabiner.json.symlink ~/.config/karabiner/karabiner.json
else
  xecho_error "karabiner" "Couldn't symlink karabiner configuration – Repeat execution once access privileges are granted to Karabiner."
fi

if [ -d ~/.warp/ ]; then
  xecho_info "warp", "Copying themes to warp themes folder"
  cp $(pwd)/warp/*.yml ~/.warp/themes/
  xecho_info "warp", "Copying keybindings to warp folder"
  ln -s -i $(pwd)/warp/keybindings.yaml.symlink ~/.warp/keybindings.yaml
else
  xecho_error "warp" "Couldn't locate warp folder."
fi

if [ -d ~/Library/Application\ Support/Godot/ ]; then
  xecho_info "godot" "Symlink .dotfiles editor_settings-4.tres"
  ln -s -i $(pwd)/godot/editor_settings-4.tres.symlink ~/Library/Application\ Support/Godot/editor_settings-4.tres
else
  xecho_info "godot" "Couldn't locate Godot installation directory"
fi

if [[ -n "$vault_path" ]]; then
  sh "$(dirname "$0")/obsidian/setup.sh" --vault "$vault_path"
fi

if [ "$skip_dock_setup" = true ]; then
  xecho_info "macos" "Skipping dock setup"
else
  xecho_info "macos" "Set dock"
  chmod +x macos/set_dock.sh
  sh -c macos/set_dock.sh
fi

#!/usr/bin/env bash

source "$(dirname "$0")/../lib/helpers.sh"

dotfiles_dir="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v zed >/dev/null 2>&1; then
  xecho_error "zed" "Zed command not found — run 'brew bundle install' to install Brewfile dependencies"
  exit 1
fi

xecho_info "zed" "Symlink keybindings to Zed"
mkdir -p ~/.config/zed
ln -shf "$dotfiles_dir/zed/keymap.json.symlink" ~/.config/zed/keymap.json

xecho_info "zed" "Symlink settings to Zed"
ln -shf "$dotfiles_dir/zed/settings.json.symlink" ~/.config/zed/settings.json

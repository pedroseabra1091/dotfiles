#!/usr/bin/env bash

source "$(dirname "$0")/../lib/helpers.sh"

dotfiles_dir="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v cursor >/dev/null 2>&1; then
  xecho_error "cursor" "Cursor command not found — run 'brew bundle install' to install Brewfile dependencies"
  exit 1
fi

xecho_info "cursor" "Installing Cursor extensions"
grep -v '^#' "$dotfiles_dir/cursor/cursor-extensions.list" | xargs -L1 cursor --install-extension

xecho_info "cursor" "Symlink keybindings to Cursor"
ln -shf "$dotfiles_dir/cursor/keybindings-cursor.json.symlink" ~/Library/Application\ Support/Cursor/User/keybindings.json

xecho_info "cursor" "Symlink settings to Cursor"
ln -shf "$dotfiles_dir/cursor/settings.json.symlink" ~/Library/Application\ Support/Cursor/User/settings.json

xecho_info "cursor" "Symlink keybindings to secondary profiles"
profiles=$(find ~/Library/Application\ Support/Cursor/User/profiles/ -mindepth 1 -maxdepth 1 -type d 2>/dev/null | awk -F 'profiles/' '{print $2}')
while IFS= read -r profile; do
  [[ -z "$profile" ]] && continue
  ln -shf "$dotfiles_dir/cursor/keybindings-cursor.json.symlink" "$HOME/Library/Application Support/Cursor/User/profiles/$profile/keybindings.json"
  ln -shf "$dotfiles_dir/cursor/settings.json.symlink" "$HOME/Library/Application Support/Cursor/User/profiles/$profile/settings.json"
done <<< "$profiles"

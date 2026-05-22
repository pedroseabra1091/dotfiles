#!/usr/bin/env bash

source "$(dirname "$0")/../lib/helpers.sh"

if ! command -v claude >/dev/null 2>&1; then
  xecho_info "claude" "Installing Claude Code via official installer"
  curl -fsSL https://claude.ai/install.sh | bash
else
  xecho_info "claude" "Claude Code already installed"
fi

dotfiles_dir="$(cd "$(dirname "$0")/.." && pwd)"

find "$dotfiles_dir/claude" -name '*.symlink' | while read -r src; do
  dest="$HOME/.claude/${src#$dotfiles_dir/claude/}"
  dest="${dest%.symlink}"
  mkdir -p "$(dirname "$dest")"
  xecho_info "claude" "Symlink ${dest#$HOME/.claude/}"
  ln -s -i "$src" "$dest"
done

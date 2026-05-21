#!/usr/bin/env bash

source "$(dirname "$0")/../lib/helpers.sh"

if ! command -v claude >/dev/null 2>&1; then
  xecho_info "claude" "Installing Claude Code via official installer"
  curl -fsSL https://claude.ai/install.sh | bash
else
  xecho_info "claude" "Claude Code already installed"
fi

mkdir -p "$HOME/.claude/skills"

dotfiles_dir="$(cd "$(dirname "$0")/.." && pwd)"

for file in "$dotfiles_dir"/claude/*.symlink; do
  [ -e "$file" ] || continue
  filename="$(basename "$file" .symlink)"
  xecho_info "claude" "Symlink $filename"
  ln -s -i "$file" "$HOME/.claude/$filename"
done

for skill in "$dotfiles_dir"/claude/skills/*.symlink; do
  [ -e "$skill" ] || continue
  skill_name="$(basename "$skill" .symlink)"
  xecho_info "claude" "Symlink skill $skill_name"
  ln -s -i "$skill" "$HOME/.claude/skills/$skill_name"
done

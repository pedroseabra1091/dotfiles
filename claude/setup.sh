#!/usr/bin/env bash

source "$(dirname "$0")/../lib/helpers.sh"

if ! command -v claude >/dev/null 2>&1; then
  xecho_info "claude" "Installing Claude Code via official installer"
  curl -fsSL https://claude.ai/install.sh | bash
else
  xecho_info "claude" "Claude Code already installed"
fi

xecho_info "claude" "$(pwd)/CLAUDE.md.symlink to ~/.claude/"
ln -s -i $(pwd)/CLAUDE.md.symlink ~/.claude/CLAUDE.md

xecho_info "claude" "$(pwd)/settings.json.symlink to ~/.claude/"
ln -s -i $(pwd)/settings.json.symlink ~/.claude/settings.json

for skill in "$(pwd)/skills"/*.symlink; do
  [ -e "$skill" ] || continue
  skill_name="$(basename "$skill" .symlink)"
  dest="$HOME/.claude/skills/$skill_name"
  xecho_info "claude" "Symlink $skill to $dest"
  ln -shf "$skill" "$dest"
done

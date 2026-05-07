#!/usr/bin/env bash

source "$(dirname "$0")/../lib/helpers.sh"

vault_path=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --vault | -v) vault_path="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [[ -z "$vault_path" ]]; then
  xecho_error "obsidian" "Missing required flag: --vault <path>"
  exit 1
fi

if [[ ! -d "$vault_path" ]]; then
  xecho_error "obsidian" "Vault path does not exist: $vault_path"
  exit 1
fi

obsidian_dir="$vault_path/.obsidian"
dotfiles_dir="$(cd "$(dirname "$0")/.." && pwd)"

for file in "$dotfiles_dir"/obsidian/*.symlink; do
  filename="$(basename "$file" .symlink)"
  xecho_info "obsidian" "Symlink $filename"
  ln -s -i "$file" "$obsidian_dir/$filename"
done

for file in "$dotfiles_dir"/obsidian/snippets/*.symlink; do
  filename="$(basename "$file" .symlink)"
  xecho_info "obsidian" "Symlink snippets/$filename"
  ln -s -i "$file" "$obsidian_dir/snippets/$filename"
done

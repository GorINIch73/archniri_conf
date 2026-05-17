#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_item() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        printf 'ok      %s\n' "$target"
        return
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "${target#$HOME/}")"
        mv "$target" "$BACKUP_DIR/${target#$HOME/}"
        printf 'backup  %s\n' "$target"
    fi

    ln -s "$source" "$target"
    printf 'link    %s -> %s\n' "$target" "$source"
}

while IFS= read -r -d '' file; do
    rel="${file#"$ROOT_DIR/config/"}"
    link_item "$file" "$HOME/.config/$rel"
done < <(find "$ROOT_DIR/config" -type f -print0)

while IFS= read -r -d '' file; do
    rel="${file#"$ROOT_DIR/home/"}"
    link_item "$file" "$HOME/$rel"
done < <(find "$ROOT_DIR/home" -type f -print0)

echo
echo "Dotfiles linked."
if [[ -d "$BACKUP_DIR" ]]; then
    echo "Backups, if any, are in: $BACKUP_DIR"
fi


#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S-%N)"

reset_nvim=false
for arg in "$@"; do
    case "$arg" in
        --reset-nvim-config) reset_nvim=true ;;
        *) printf 'Unknown option: %s\nUsage: %s [--reset-nvim-config]\n' "$arg" "$0" >&2; exit 1 ;;
    esac
done

if "$reset_nvim" && [[ -e "$HOME/.config/nvim" || -L "$HOME/.config/nvim" ]]; then
    mkdir -p "$BACKUP_DIR/.config"
    mv "$HOME/.config/nvim" "$BACKUP_DIR/.config/nvim"
    printf 'backup  %s\n' "$HOME/.config/nvim"
fi

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

# Waybar prefers config over config.jsonc. Keep both names on the active
# profile, including when setup-laptop.sh switches config.jsonc later.
link_item "$HOME/.config/waybar/config.jsonc" "$HOME/.config/waybar/config"

while IFS= read -r -d '' file; do
    rel="${file#"$ROOT_DIR/home/"}"
    link_item "$file" "$HOME/$rel"
done < <(find "$ROOT_DIR/home" -type f -print0)

echo
echo "Dotfiles linked."
if [[ -d "$BACKUP_DIR" ]]; then
    echo "Backups, if any, are in: $BACKUP_DIR"
fi

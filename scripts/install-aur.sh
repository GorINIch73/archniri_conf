#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_FILE="$ROOT_DIR/packages/aur.txt"

mapfile -t PACKAGES < <(grep -Ev '^\s*(#|$)' "$PACKAGE_FILE")

if [[ "${#PACKAGES[@]}" -eq 0 ]]; then
    echo "No AUR packages listed."
    exit 0
fi

ensure_yay() {
    if command -v yay >/dev/null 2>&1; then
        return 0
    fi

    if command -v paru >/dev/null 2>&1; then
        return 1
    fi

    echo "No AUR helper found. Installing yay-bin..."
    local build_dir
    build_dir="$(mktemp -d)"
    trap 'rm -rf "$build_dir"' RETURN

    git clone https://aur.archlinux.org/yay-bin.git "$build_dir/yay-bin"
    (cd "$build_dir/yay-bin" && makepkg -si --noconfirm --needed)
}

helper="yay"
if ! ensure_yay; then
    helper="paru"
fi

echo "Installing ${#PACKAGES[@]} AUR packages with $helper..."
"$helper" -S --needed --noconfirm "${PACKAGES[@]}"

echo
echo "AUR packages installed."

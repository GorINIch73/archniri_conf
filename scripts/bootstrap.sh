#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_FILE="$ROOT_DIR/packages/pacman.txt"

mapfile -t PACKAGES < <(grep -Ev '^\s*(#|$)' "$PACKAGE_FILE")

echo "Installing ${#PACKAGES[@]} pacman packages..."
sudo pacman -Syu --needed "${PACKAGES[@]}"

echo
echo "Bootstrap complete."

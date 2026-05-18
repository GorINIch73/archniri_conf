#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_FILE="$ROOT_DIR/packages/laptop.txt"
LAPTOP_WAYBAR_CONFIG="$ROOT_DIR/config/waybar/config.laptop.jsonc"
ACTIVE_WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"

mapfile -t PACKAGES < <(grep -Ev '^\s*(#|$)' "$PACKAGE_FILE")

echo "Installing ${#PACKAGES[@]} laptop packages..."
sudo pacman -Syu --needed "${PACKAGES[@]}"

echo
echo "Switching Waybar to the laptop profile..."
mkdir -p "$(dirname "$ACTIVE_WAYBAR_CONFIG")"
ln -sfn "$LAPTOP_WAYBAR_CONFIG" "$ACTIVE_WAYBAR_CONFIG"

echo
echo "Enabling power-profiles-daemon..."
sudo systemctl enable --now power-profiles-daemon.service

echo
echo "Laptop extras enabled."
echo "- Waybar now shows battery status and the active power profile."
echo "- Use powerprofilesctl to inspect or change the active profile."


#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE_FILE="$ROOT_DIR/packages/pacman.txt"

mapfile -t PACKAGES < <(grep -Ev '^\s*(#|$)' "$PACKAGE_FILE")

missing_packages=()
for package in "${PACKAGES[@]}"; do
    if ! pacman -Si "$package" >/dev/null 2>&1; then
        missing_packages+=("$package")
    fi
done

if [[ "${#missing_packages[@]}" -gt 0 ]]; then
    echo "These packages are not available in the enabled pacman repositories:"
    printf '  %s\n' "${missing_packages[@]}"

    if printf '%s\n' "${missing_packages[@]}" | grep -Eq '^(steam|steam-devices)$'; then
        cat <<'EOF'

Steam packages are in Arch's multilib repository. Enable it in /etc/pacman.conf:

[multilib]
Include = /etc/pacman.d/mirrorlist

Then run:

sudo pacman -Syu
./setup.sh
EOF
    fi

    echo
    echo "If a package is only available in AUR, move it from packages/pacman.txt to packages/aur.txt."
    exit 1
fi

echo "Installing ${#PACKAGES[@]} pacman packages..."
sudo pacman -Syu --needed "${PACKAGES[@]}"

echo
echo "Bootstrap complete."

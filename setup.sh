#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_step() {
    local title="$1"
    shift

    echo
    printf '==> %s\n' "$title"
    "$@"
}

run_step "Installing packages" "$ROOT_DIR/scripts/bootstrap.sh"
run_step "Installing zsh extras" "$ROOT_DIR/scripts/install-zsh-extras.sh"
run_step "Linking dotfiles" "$ROOT_DIR/scripts/link-dotfiles.sh"
run_step "Applying appearance settings" "$ROOT_DIR/scripts/apply-appearance.sh"

echo
install_laptop=""
read -r -p "Install laptop extras (battery status and power management)? [y/N] " install_laptop || true
case "${install_laptop,,}" in
    y|yes)
        run_step "Installing laptop extras" "$ROOT_DIR/scripts/setup-laptop.sh"
        ;;
esac

run_step "Preparing wallpaper directory" mkdir -p "$HOME/Downloads/Wallpapers"

run_step "Reloading user systemd units" systemctl --user daemon-reload
run_step "Enabling wallpaper rotation" systemctl --user enable --now wallpaper-rotate.timer
run_step "Enabling Syncthing" systemctl --user enable --now syncthing.service

run_step "Checking setup" "$ROOT_DIR/scripts/check-setup.sh"

echo
echo "Initial setup complete."
echo "Next manual steps:"
echo "- Log into the niri session."
echo "- Put wallpapers into $HOME/Downloads/Wallpapers."
echo "- Open a fresh terminal so Powerlevel10k loads."
echo "- Open Neovim once and let plugins install."

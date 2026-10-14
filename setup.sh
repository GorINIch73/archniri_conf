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

run_user_systemctl() {
    if ! systemctl --user "$@"; then
        echo "warning: systemctl --user $* failed; run it again after logging into a user session"
    fi
}

ask_optional_setup() {
    local prompt="$1"
    local script="$2"
    local answer=""

    echo
    read -r -p "$prompt [y/N] " answer || true
    case "${answer,,}" in
        y|yes) run_step "$prompt" "$ROOT_DIR/scripts/$script" ;;
    esac
}

run_step "Installing packages" "$ROOT_DIR/scripts/bootstrap.sh"
run_step "Installing AUR packages" "$ROOT_DIR/scripts/install-aur.sh"
run_step "Installing zsh extras" "$ROOT_DIR/scripts/install-zsh-extras.sh"
run_step "Linking dotfiles" "$ROOT_DIR/scripts/link-dotfiles.sh"
run_step "Applying appearance settings" "$ROOT_DIR/scripts/apply-appearance.sh"

ask_optional_setup "Install laptop extras (battery status and power management)?" "setup-laptop.sh"
ask_optional_setup "Set up Samba file sharing?" "setup-samba.sh"
ask_optional_setup "Set up printer support (CUPS)?" "setup-printers.sh"

run_step "Preparing wallpaper directory" mkdir -p "$HOME/Downloads/Wallpapers"

run_step "Reloading user systemd units" run_user_systemctl daemon-reload
run_step "Enabling wallpaper rotation" run_user_systemctl enable --now wallpaper-rotate.timer
run_step "Enabling Syncthing" run_user_systemctl enable --now syncthing.service

run_step "Checking setup" "$ROOT_DIR/scripts/check-setup.sh"

echo
echo "Initial setup complete."
echo "Next manual steps:"
echo "- Log into the niri session."
echo "- Put wallpapers into $HOME/Downloads/Wallpapers."
echo "- Open a fresh terminal so Powerlevel10k loads."
echo "- Open Neovim once and let plugins install."

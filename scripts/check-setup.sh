#!/usr/bin/env bash
set -euo pipefail

ok()   { printf 'ok      %s\n' "$1"; }
warn() { printf 'missing %s\n' "$1"; }

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

echo "Commands"
for cmd in \
    niri xwayland-satellite waybar fuzzel mako kitty nvim clangd steam awww \
    grim slurp wl-copy wl-paste cliphist wlogout swaylock swayidle wpctl \
    notify-send playerctl brightnessctl pavucontrol imv mpv zathura file \
    mediainfo bat fd rg fzf jq curl pgrep gparted mkfs.fat mkfs.exfat \
    wf-recorder \
    localsend_app satty trash-put duf dust ncdu eza zoxide tldr just \
    shellcheck shfmt
do
    if has_cmd "$cmd"; then
        ok "$cmd"
    else
        warn "$cmd"
    fi
done

echo
echo "Linked config"
for path in \
    "$HOME/.config/niri/config.kdl" \
    "$HOME/.config/waybar/config.jsonc" \
    "$HOME/.config/waybar/style.css" \
    "$HOME/.config/fuzzel/fuzzel.ini" \
    "$HOME/.config/mako/config" \
    "$HOME/.config/kitty/kitty.conf" \
    "$HOME/.config/nvim/init.lua" \
    "$HOME/.zshrc" \
    "$HOME/.p10k.zsh"
do
    if [[ -L "$path" || -e "$path" ]]; then
        ok "$path"
    else
        warn "$path"
    fi
done

echo
echo "User scripts"
for path in \
    "$HOME/.local/bin/theme-switch" \
    "$HOME/.local/bin/theme-menu" \
    "$HOME/.local/bin/discord-stable" \
    "$HOME/.local/bin/next-wallpaper" \
    "$HOME/.local/bin/clipboard-picker" \
    "$HOME/.local/bin/screenshot" \
    "$HOME/.local/bin/microphone-status" \
    "$HOME/.local/bin/toggle-microphone" \
    "$HOME/.local/bin/public-ip-status" \
    "$HOME/.local/bin/awg-gor2-status" \
    "$HOME/.local/bin/lfcd"
do
    if [[ -x "$path" ]]; then
        ok "$path"
    else
        warn "$path"
    fi
done

echo
echo "Theme switcher"
if [[ -x "$HOME/.local/bin/theme-switch" ]]; then
    printf 'themes  '
    "$HOME/.local/bin/theme-switch" --list | paste -sd ' ' -
    printf 'waybar  '
    "$HOME/.local/bin/theme-switch" --modes | paste -sd ' ' -
else
    warn "theme-switch unavailable"
fi

echo
echo "Wallpaper rotation"
timer_state="$(systemctl --user is-enabled wallpaper-rotate.timer 2>&1)" || timer_status=$?
timer_status="${timer_status:-0}"

if [[ "$timer_status" -eq 0 ]]; then
    ok "wallpaper-rotate.timer enabled"
elif grep -qi "Failed to connect to user scope bus" <<<"$timer_state"; then
    printf 'unknown %s\n' "wallpaper-rotate.timer (user systemd bus unavailable)"
else
    warn "wallpaper-rotate.timer not enabled"
fi

if [[ -d "$HOME/Downloads/Wallpapers" ]]; then
    ok "$HOME/Downloads/Wallpapers"
else
    warn "$HOME/Downloads/Wallpapers"
fi

echo
echo "Notes"
echo "- Switch theme: theme-menu or theme-switch <theme> [calm|colorful]"
echo "- Discord launcher uses discord-stable to avoid frozen Electron frames"
echo "- Steam launch profiles: docs/gaming.md"
echo "- Optional laptop setup: scripts/setup-laptop.sh"
echo "- Full checklist: docs/post-install.md"

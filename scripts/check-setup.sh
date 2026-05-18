#!/usr/bin/env bash
set -euo pipefail

ok()   { printf 'ok      %s\n' "$1"; }
warn() { printf 'missing %s\n' "$1"; }

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

echo "Commands"
for cmd in niri waybar fuzzel mako kitty nvim clangd steam awww grim slurp cliphist wlogout swaylock wpctl notify-send; do
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
echo "- Steam launch profiles: docs/gaming.md"
echo "- Full checklist: docs/post-install.md"

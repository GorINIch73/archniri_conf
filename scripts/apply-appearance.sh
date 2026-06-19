#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
theme="${1:-mocha}"
waybar_mode="${2:-calm}"

if command -v theme-switch >/dev/null 2>&1; then
    theme-switch "$theme" "$waybar_mode"
else
    "$ROOT_DIR/home/.local/bin/theme-switch" "$theme" "$waybar_mode"
fi

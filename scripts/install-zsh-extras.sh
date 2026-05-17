#!/usr/bin/env bash
set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
SYNTAX_HIGHLIGHTING_DIR="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

install_or_update() {
    local repo="$1"
    local dir="$2"

    if [[ -d "$dir/.git" ]]; then
        git -C "$dir" pull --ff-only
    else
        git clone --depth=1 "$repo" "$dir"
    fi
}

install_or_update https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
install_or_update https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
install_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHTING_DIR"

echo "Powerlevel10k and zsh plugins are ready."

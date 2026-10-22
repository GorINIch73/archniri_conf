#!/usr/bin/env bash
set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
OMZ_DIR="${ZSH:-$HOME/.oh-my-zsh}"
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
SYNTAX_HIGHLIGHTING_DIR="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

install_or_update() {
    local repo="$1"
    local dir="$2"

    if [[ -d "$dir/.git" ]]; then
        git -C "$dir" pull --ff-only
    elif [[ -e "$dir" ]]; then
        echo "Cannot clone $repo: $dir exists but is not a git repository." >&2
        return 1
    else
        git clone --depth=1 "$repo" "$dir"
    fi
}

if [[ -d "$OMZ_DIR" && ! -d "$OMZ_DIR/.git" ]]; then
    tmp_omz="$(mktemp -d)"
    trap 'rm -rf "$tmp_omz"' RETURN

    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$tmp_omz"
    cp -a "$tmp_omz/." "$OMZ_DIR/"
else
    install_or_update https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
fi
mkdir -p "$ZSH_CUSTOM/themes" "$ZSH_CUSTOM/plugins"

install_or_update https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
install_or_update https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
install_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHTING_DIR"

echo "Oh My Zsh, the Powerlevel10k theme, and zsh plugins are ready."
echo "The linked ~/.zshrc selects Powerlevel10k and loads ~/.p10k.zsh."

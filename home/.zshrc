export EDITOR="nvim"
export VISUAL="nvim"
export MC_SKIN="nicedark"
export PATH="$HOME/.local/bin:$PATH"

# Enable Powerlevel10k instant prompt. Keep this near the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

alias ll='ls -lah'
alias la='ls -A'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit --amend'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gco='git checkout'
alias lg='git log --oneline --graph --decorate'
alias v='nvim'
alias l='lf'

lfcd() {
  local dir
  dir="$(command lfcd "$@")" || return
  [[ -n "$dir" ]] && cd "$dir"
}

alias cbuild='cmake --build build/${CMAKE_BUILD_TYPE:-Debug}'
alias cconf='cmake -S . -B build/${CMAKE_BUILD_TYPE:-Debug} -G Ninja -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:-Debug} -DCMAKE_EXPORT_COMPILE_COMMANDS=1'
alias crun='./build/${CMAKE_BUILD_TYPE:-Debug}/app'
alias cclean='rm -rf build'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

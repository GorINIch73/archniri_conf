# A small pastel prompt for the MangoWC trial, compatible with Oh My Zsh.
# Install as ~/.oh-my-zsh/custom/themes/mango-kawaii.zsh-theme and select with
# ZSH_THEME="mango-kawaii". Nerd Font glyphs are optional.

PROMPT='%F{magenta}✿%f %F{cyan}%~%f $(git_prompt_info)\n%F{magenta}♡%f '
ZSH_THEME_GIT_PROMPT_PREFIX='%F{blue}‹'
ZSH_THEME_GIT_PROMPT_SUFFIX='›%f '
ZSH_THEME_GIT_PROMPT_DIRTY='%F{yellow}✧%f'
ZSH_THEME_GIT_PROMPT_CLEAN='%F{green}✓%f'


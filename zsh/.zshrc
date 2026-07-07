# ~/.zshrc - main entry point
#
# This file is symlinked from ~/dotfiles/zsh/.zshrc.
# Shell config is split into modules under ~/dotfiles/zsh/, each symlinked
# into $HOME so it can be sourced independently.
#
# Edit a module via its symlink in $HOME, e.g.  n ~/.aliases

# 1. Oh My Zsh: declare ZSH, theme and plugins first, then init OMZ.
[[ -f "$HOME/.plugins" ]] && source "$HOME/.plugins"
[[ -n "$ZSH" && -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# 2. Environment variables & PATH (mise is activated at the end).
[[ -f "$HOME/.exports" ]] && source "$HOME/.exports"

# 3. Aliases
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# 4. Functions
[[ -f "$HOME/.functions" ]] && source "$HOME/.functions"

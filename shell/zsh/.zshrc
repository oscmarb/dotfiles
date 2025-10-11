#!/usr/bin/env zsh

export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="robbyrussell"

autoload -U compinit
compinit

source "$DOTFILES_PATH/shell/.shellrc"
source "$DOTFILES_PATH/shell/completions/_main"

DISABLE_AUTO_UPDATE="true"
ZSH_AUTOSUGGEST_USE_ASYNC="true"

# ZSH Ops
setopt HIST_FCNTL_LOCK
setopt +o nomatch
setopt autopushd

# History
HISTSIZE=10000
SAVEHIST=10000

zle_highlight=(paste:none)

zstyle ':omz:plugins:nvm' lazy yes

export plugins=(
  nvm
  zsh-completions
  autojump
  extract
  aliases
  fzf-tab
  you-should-use
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH"/oh-my-zsh.sh

_reverse_search() {
  local selected_command=$(fc -rl 1 | awk '{$1=""; cmd=substr($0,2); if (!seen[cmd]++) print cmd}' | fzf --scheme=history)
  LBUFFER=$selected_command
}

zle -N _reverse_search
bindkey '^r' _reverse_search

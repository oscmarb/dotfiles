#!/usr/bin/env zsh

ZSH_AUTOSUGGEST_USE_ASYNC="true"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -U compinit

if [[ ! -f ${ZDOTDIR:-$HOME}/.zcompdump || -n $(find "${ZDOTDIR:-$HOME}/.zcompdump" -mtime +1 -print 2>/dev/null) ]]; then
  compinit # Re-builds the completion cache
  zinit cclear
else
  compinit -C # Use completion cache
fi

# THEME
ZSH_THEME="robbyrussell"
zi snippet OMZL::git.zsh            # Must Load OMZ Git library
zi snippet OMZL::async_prompt.zsh   # Must Load OMZ Async prompt library
zi snippet OMZP::git                # Load Git plugin from OMZ
zi cdclear -q                       # Forget completions provided up to this moment
setopt promptsubst
zi snippet OMZT::robbyrussell       # Load Prompt
# THEME END

setopt +o nomatch

zle_highlight=(paste:none)          # Disables highlighting when pasting text

# DIRECTORY NAVIGATION
setopt AUTO_CD                      # cd by typing directory name if it's not a command
setopt AUTO_PUSHD                   # Make cd push old directory onto stack
setopt PUSHD_IGNORE_DUPS            # Don't push duplicates onto directory stack
setopt PUSHD_SILENT                 # Don't print directory stack after pushd/popd
setopt PUSHD_TO_HOME                # pushd with no args goes to $HOME
# END DIRECTORY NAVIGATION

setopt interactive_comments         # Allowing Comments in Interactive Shells

# HISTORY
HISTSIZE=10000                      # Max commands in memory
SAVEHIST=$HISTSIZE                  # Max commands saved to file
HISTFILE=~/.zsh_history             # Where to save history

setopt EXTENDED_HISTORY             # Write timestamp to history file
setopt HIST_EXPIRE_DUPS_FIRST       # Expire duplicate entries first
setopt HIST_IGNORE_DUPS             # Don't record duplicate consecutive commands
setopt HIST_IGNORE_ALL_DUPS         # Delete old duplicates
setopt HIST_FIND_NO_DUPS            # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE            # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS            # Don't save duplicates
setopt HIST_REDUCE_BLANKS           # Remove extra blanks from commands
setopt HIST_VERIFY                  # Show command with history expansion before running
setopt HIST_FCNTL_LOCK              # Use fcntl for history file locking
# END HISTORY

# PLUGINS
# zi snippet OMZP::autojump # Disabled because it degrades startup Zsh performance
zi light zsh-users/zsh-autosuggestions
zi light zsh-users/zsh-syntax-highlighting
zi light zsh-users/zsh-completions
zi light Aloxaf/fzf-tab
# PLUGINS END

source "$DOTFILES_PATH/shell/.shellrc"
source "$DOTFILES_PATH/shell/completions/_main"

_reverse_search() {
  local selected_command=$(fc -rl 1 | awk '{$1=""; cmd=substr($0,2); if (!seen[cmd]++) print cmd}' | fzf --scheme=history)
  LBUFFER=$selected_command
}

zle -N _reverse_search
bindkey '^r' _reverse_search

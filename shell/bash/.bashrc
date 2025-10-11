export DOTFILES_PATH="$HOME/.dotfiles"
export SHELL="/bin/bash"

source "$DOTFILES_PATH/shell/.shellrc"

# Load nvm. Only for bash as zsh has its own way of loading nvm
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

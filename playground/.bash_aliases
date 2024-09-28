# cargo
. "$HOME/.cargo/env"

# pipx
eval "$(register-python-argcomplete pipx)"
export PATH="$PATH:$HOME/.local/bin"

# Node
NVM_DIRECTORY="$HOME/.nvm"
if [ -d "$NVM_DIRECTORY" ]
  then
    export NVM_DIR="$NVM_DIRECTORY"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# starship
eval "$(starship init bash)"

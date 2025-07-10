#!/bin/bash

# Place commands here, instead of in .bashrc, in case it's replaced via docker-compose.yml
# Of course be sure to call this in the replacing .bashrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

npm install watch -g

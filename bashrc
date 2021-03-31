#!/bin/bash

alias b="bundle"
alias be="bundle exec"

# rbenv
which rbenv &> /dev/null || export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local
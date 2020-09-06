#!/bin/bash

alias b="bundle"
alias be="bundle exec"

which rbenv &> /dev/null || export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local

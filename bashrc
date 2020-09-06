#!/bin/bash

alias b="bundle"
alias be="bundle exec"

eval "$(rbenv init -)"

[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local

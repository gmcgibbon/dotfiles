#!/bin/bash

source ~/.antigen/bin/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme mortalscumbag
antigen apply

alias b="bundle"
alias be="bundle exec"

eval "$(rbenv init -)"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

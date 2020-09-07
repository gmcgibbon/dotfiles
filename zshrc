#!/bin/bash

source ~/.zsh/antigen/bin/antigen.zsh

if [[ $ANTIGEN_APPLIED != true ]]; then
  antigen use oh-my-zsh
  antigen bundle git
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen apply
fi
export ANTIGEN_APPLIED=true

source ~/.zsh/themes/sparkle.zsh

source ~/.bashrc

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

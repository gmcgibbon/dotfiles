#!/bin/zsh

source ~/.bashrc

source ~/.zsh/antigen/bin/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle nvm
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

source ~/.zsh/themes/sparkle.zsh-theme

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

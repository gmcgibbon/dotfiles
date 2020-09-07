#!/bin/bash

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[black]%}(ssh) "
  fi
}

PROMPT='$(ssh_connection)'
PROMPT+='%{${fg_bold[red]}%}%m '
PROMPT+='✨ '
PROMPT+='%{${fg_bold[magenta]}%}%c '
PROMPT+='$(git_prompt_info)'
PROMPT+='%{${fg_bold[cyan]}%}[%?] '
PROMPT+='%{${fg_bold[white]}%}%#'
PROMPT+='%{${reset_color}%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}<"
ZSH_THEME_GIT_PROMPT_SUFFIX="> %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=":✘"
ZSH_THEME_GIT_PROMPT_CLEAN=":✔"

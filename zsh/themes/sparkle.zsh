#!/bin/zsh

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[magenta]%}(ssh) "
  fi
}

PROMPT='$(ssh_connection)'
PROMPT+='✨ '
PROMPT+='%{${fg_bold[yellow]}%}%c '
PROMPT+='$(git_prompt_info)'
PROMPT+='%{${fg_bold[grey]}%}[%?] '
PROMPT+='%{${fg_bold[white]}%}%#'
PROMPT+='%{${reset_color}%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[red]%}<"
ZSH_THEME_GIT_PROMPT_SUFFIX="> %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=":✘"
ZSH_THEME_GIT_PROMPT_CLEAN=":✔"

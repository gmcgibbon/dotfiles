function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "${BOLD_MAGENTA}(ssh) "
  fi
}

BOLD_MAGENTA="%{%B%F{magenta}%}"
BOLD_YELLOW="%{%B%F{yellow}%}"
BOLD_GREY="%{%B%F{#566573}%}"
BOLD_WHITE="%{%B%F{white}%}"
BOLD_RED="%{%B%F{red}%}"
CLEAR="%{%f%k%b%}"


PROMPT='$(ssh_connection)'
PROMPT+="✨ "
PROMPT+="${BOLD_YELLOW}%c${CLEAR} "
PROMPT+='$(git_prompt_info)'
PROMPT+="${BOLD_GREY}[%?] "
PROMPT+="${BOLD_WHITE}# "
PROMPT+="${CLEAR}"

ZSH_THEME_GIT_PROMPT_PREFIX="${BOLD_RED}<"
ZSH_THEME_GIT_PROMPT_SUFFIX="> ${CLEAR}"
ZSH_THEME_GIT_PROMPT_DIRTY=":✘"
ZSH_THEME_GIT_PROMPT_CLEAN=":✔"

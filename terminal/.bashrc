#!/bin/bash

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# source aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

export EDITOR='nvim'
export VISUAL='nvim'

# Disable the bell
if [[ $iatest > 0 ]]; then bind "set bell-style visible"; fi

PROMPT_COMMAND='history -a'
shopt -s checkwinsize
bind 'set completion-ignore-case on'
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(starship init bash)"
# eval "$(atuin init bash)"
eval "$(zoxide init bash)"

# Cargo
export PATH=$PATH:/home/yehuda/.local/bin
. "$HOME/.cargo/env"

export HSTR_CONFIG=hicolor      # get more colors
shopt -s histappend             # append new history items to .bash_history
export HISTCONTROL=ignorespace  # leading space hides commands from history
export HISTFILESIZE=10000       # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE} # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
function hstrnotiocsti {
  { READLINE_LINE="$({ </dev/tty hstr ${READLINE_LINE}; } 2>&1 1>&3 3>&-)"; } 3>&1
  READLINE_POINT=${#READLINE_LINE}
}
if [[ $- =~ .*i.* ]]; then bind -x '"\C-r": "hstrnotiocsti"'; fi
export HSTR_TIOCSTI=n

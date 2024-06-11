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
eval "$(atuin init bash)"
eval "$(zoxide init bash)"

# Cargo
export PATH=$PATH:/home/yehuda/.local/bin
. "$HOME/.cargo/env"

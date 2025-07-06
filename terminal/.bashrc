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
export COMPOSE_BAKE=true
export _ZO_DOCTOR=0

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

# Cargo
export PATH=$PATH:/home/yehuda/.local/bin
. "$HOME/.cargo/env"

export HSTR_CONFIG=hicolor      # get more colors
shopt -s histappend             # append new history items to .bash_history
export HISTCONTROL=ignorespace  # leading space hides commands from history
export HISTFILESIZE=50000       # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE} # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
function hstrnotiocsti {
  { READLINE_LINE="$({ </dev/tty hstr ${READLINE_LINE}; } 2>&1 1>&3 3>&-)"; } 3>&1
  READLINE_POINT=${#READLINE_LINE}
}
if [[ $- =~ .*i.* ]]; then bind -x '"\C-r": "hstrnotiocsti"'; fi
export HSTR_TIOCSTI=n
export PATH=$PATH:$(go env GOPATH)/bin
eval "$(direnv hook bash)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export CAPACITOR_ANDROID_STUDIO_PATH=/usr/bin/android-studio

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

eval "$(zoxide init bash --cmd cd)"
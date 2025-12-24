#!/bin/bash

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi


export EDITOR='nvim'
export VISUAL='nvim'

export COMPOSE_BAKE=true
export _ZO_DOCTOR=0

if [[ $iatest > 0 ]]; then bind "set bell-style visible"; fi

PROMPT_COMMAND='history -a'

export HISTCONTROL=ignoredups
shopt -s checkwinsize
bind 'set completion-ignore-case on'
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export PATH=$PATH:/home/yehuda/.local/bin
. "$HOME/.cargo/env"

export HSTR_CONFIG=hicolor      # get more colors
shopt -s histappend             # append new history items to .bash_history
export HISTFILESIZE=50000       # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE} # increase history size (default is 500)

export PATH=$PATH:$(go env GOPATH)/bin

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export CAPACITOR_ANDROID_STUDIO_PATH=/usr/bin/android-studio

export JAVA_HOME=/usr/lib/jvm/java-24-openjdk
export ANDROID_HOME=~/Android/Sdk
export ANDROID_SDK_ROOT=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin

eval "$(starship init bash)"
eval "$(direnv hook bash)"
eval "$(zoxide init bash --cmd cd)"
export PATH="$HOME/.claude/local:$PATH"

# Welcome message on login
[[ -f "$HOME/dotfiles/terminal/welcome.sh" ]] && . "$HOME/dotfiles/terminal/welcome.sh"

# Load device-specific configuration (not synced with git)
if [ -f ~/.bashrc_local ]; then
  . ~/.bashrc_local
fi

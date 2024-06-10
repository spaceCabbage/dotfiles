# setup Zinit package manager
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d $ZINIT_HOME ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# load aliases
source ~/.bash_aliases
source ~/.zsh_aliases

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit # load completions

# CLI enhancements
eval "$(starship init zsh)"
# eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# Keybinds
bindkey -v
bindkey '^K' history-search-backward
bindkey '^J' history-search-forward

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Options
setopt auto_cd
zstyle ':completions:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:completie:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:completie:__zoxide_z:*' fzf-preview 'eza -lh --icons --no-permissions --no-user $realpath'

zinit light Aloxaf/fzf-tab

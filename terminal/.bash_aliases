##### ALIAS MASTER FILE ######

# general
alias ebrc='nvim ~/.bashrc'
alias eba='nvim ~/.bash_aliases'
alias sbrc='source ~/.bashrc'
alias stx="tmux source ~/.tmux.conf"
alias ncdu="ncdu --color dark -t 10"
alias shutdown="shutdown now"
alias ts="sudo tailscale"
alias o="ollama"alias dc="cd"
alias sl="ls"
alias ll="eza -lhaF --icons --git --group-directories-first"
alias ls="eza -lhF --icons --no-permissions --no-user --color=always"
alias lc="eza -lhF --icons --no-permissions --no-user --color=always"

# alias cd="z"
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose'
alias yy="yazi"

alias rg="rg --color=always --smart-case"
alias cat="bat -P"
alias nv='nvim .'
alias hh=hstr

# DNF
alias update='sudo dnf update -y --refresh'
alias install='sudo dnf install'

# ssh
alias moon="ssh yehuda@192.168.1.39"
alias ribis="ssh -p 2222 ribis@145.223.116.211"
alias club="ssh cork@club.corkandcellar.net -p 2222"
alias kepler="ssh -p 2222 yehuda@kepler"
alias apollo="ssh yehuda@192.168.1.40"

# Syncing
alias syncnote='cd ~/Documents/notes && git add . && git commit -m "Update notes" && git push && bd'
alias pn='cd ~/Documents/notes && git pull && bd'
alias sn="syncnote"
alias syncdot='cd ~/dotfiles/ && git add . && git commit -m "Update dotfiles" && git push && bd'
alias pd='cd ~/dotfiles/ && git pull && bd'
alias sd="syncdot"

# git
alias gc="git clone"
alias gg="lazygit"
alias gs="git status --short"
alias gf="git fetch"
alias gp="git push"
alias ga="git add *"
alias graph="serie"
# javascript
alias nrd="npm run dev"
alias nrb="npm run build"
alias ni="npm i"
alias ios="ionic serve --external"
# python
alias senv="source .env/bin/activate"
alias svenv="source venv/bin/activate"
alias pipi="python3 -m pip install -r req.txt"
alias dj="python3 manage.py"
alias djr="python3 manage.py runserver"
alias djmm="python3 manage.py makemigrations"
alias djm="python3 manage.py migrate"
alias py="python3"

# Podman (formerly Docker)
alias dcu="podman-compose up"
alias dcud="podman-compose up -d"
alias dcd="podman-compose down"
alias dcb="podman-compose up --build"
alias lzd="lazydocker"
# Additional podman aliases for convenience
alias docker="podman"
alias docker-compose="podman-compose"

# Network
alias wmip='ip route | rg "default"'

alias linutil="curl -fsSL https://christitus.com/linux | sh"

alias kill="tmux kill-session"

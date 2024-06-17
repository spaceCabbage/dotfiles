##### ALIAS MASTER FILE ######

# general
alias ebrc='nvim ~/.bashrc'
alias eba='nvim ~/.bash_aliases'
alias sbrc='source ~/.bashrc'

alias ll="eza -lhaF --icons --git --group-directories-first"
alias ls="eza -lhF --icons --no-permissions --no-user --color=always"
alias lc="eza -lhF --icons --no-permissions --no-user --color=always"

alias cd="z"
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose ' # force remove directory
alias :q="exit"

alias rg="rg --color=always --smart-case"
alias cat="bat -P"
alias nv='nvim .'
alias hh=hstr

# ssh
alias moon="ssh yehuda@192.168.1.39"

# Syncing
alias syncnote='cd ~/Documents/notes && git add . && git commit -m "Update notes" && git push && bd'
alias pn='cd ~/Documents/notes && git pull && bd'
alias sn="syncnote"
alias syncdot='cd ~/Documents/dotfiles/ && git add . && git commit -m "Update dotfiles" && git push && bd'
alias pd='cd ~/Documents/dotfiles/ && git pull && bd'
alias sd="syncdot"

# git
alias gc="git clone"
alias gg="lazygit"
alias gs="git status"
alias gf="git fetch"
alias gp="git push"
alias ga="git add *"

# javascript
alias nrd="npm run dev"
alias nrb="npm run build"
alias ni="npm i"

# python
alias senv="source .env/bin/activate"
alias svenv="source venv/bin/activate"
alias pipi="python3 -m pip install -r req.txt"
alias dj="python3 manage.py"
alias djr="python3 manage.py runserver"
alias djmm="python3 manage.py makemigrations"
alias djm="python3 manage.py migrate"
alias py="python3"

# Network
alias wmip='ip route | rg "default"'

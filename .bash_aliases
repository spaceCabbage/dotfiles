##### ALIAS MASTER FILE ######

# general
alias ebrc='nvim ~/.bashrc'
alias eba='nvim ~/.bash_aliases'
alias sbrc='source ~/.bashrc'
alias ll="ls -la"
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose ' # force remove directory

# git
alias gc="git clone"
alias gg="lazygit"
alias gs="git status"
alias gp="git pull"
alias gf="git fetch"
alias gP="git push"
alias ga="git add *"

# javascript
alias nrd="npm run dev"
alias nrb="npm run build"
alias ni="npm i"

# python
alias senv="source .env/bin/activate"
alias pipi="python3 -m pip install -r req.txt"
alias djr="python3 manage.py runserver"
alias djmm="python3 manage.py makemigrations"
alias djm="python4 manage.py migrate"

# Network
alias wmip='ip route | grep "default"'
alias tu='sudo tailscale up'
alias td='sudo tailscale down'
alias ts='sudo tailscale status'
alias checkwifi='ping 8.8.8.8'

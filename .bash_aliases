##### ALIAS MASTER FILE ######

# general
# alias install="sudo nala install"
# alias update="sudo nala update"
#alias upgrade="sudo nala upgrade -y"
alias ebrc='nvim ~/.bashrc'
alias eba='nvim ~/.bash_aliases'
alias sbrc='source ~/.bashrc'
alias ll="exa -lha --icons --git --group-directories-first"
alias ls="exa -lh --icons --no-permissions --no-user"
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose ' # force remove directory
alias grep="/usr/bin/grep"
alias hh="hstr"
alias cd="z"
#alias code="vscodium"
alias cat="bat -P"

# ssh
alias moon="ssh yehuda@moon.local"

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
alias gp="git pull"
alias gP="git push"
alias ga="git add *"

# download torrent magnet 
alias torrent='aria2c --max-connection-per-server=16 --split=16 --continue --dir="$HOME/Downloads" --enable-dht=true --enable-peer-exchange=true --seed-time=0 --console-log-level=inf'

# javascript
alias nrd="npm run dev"
alias nrb="npm run build"
alias ni="npm i"

# python
alias senv="source .env/bin/activate"
alias pipi="python3 -m pip install -r req.txt"
alias djr="python3 manage.py runserver"
alias djmm="python3 manage.py makemigrations"
alias djm="python3 manage.py migrate"

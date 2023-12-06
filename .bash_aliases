##### ALIAS MASTER FILE ######

# general
# alias install="sudo nala install"
# alias update="sudo nala update"
#alias upgrade="sudo nala upgrade -y"
alias eb='nvim ~/.bashrc'
alias ll="exa -lha --icons --git --group-directories-first"
alias ls="exa -lh --icons --no-permissions --no-user"
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose ' # force remove directory
alias grep="/usr/bin/grep"
alias hh="hstr"
alias cd="z"
#alias code="vscodium"


# Syncing
alias syncnote='cd ~/Documents/notes && git add . && git commit -m "Update notes" && git push'
alias syncdot='cd ~/Documents/dev/dotfiles/ && git add . && git commit -m "Update dotfiles" && git push'

# git
alias gc="git clone"
alias gg="lazygit"
alias gs="git status"
alias gp="git pull"
alias gP="git push"
alias ga="git add *"

alias torrent='aria2c --max-connection-per-server=16 --split=16 --continue --dir="$HOME/Downloads" --enable-dht=true --enable-peer-exchange=true --seed-time=0 --console-log-level=inf'

# javascript
alias nrd="npm run dev"
alias ni="npm i"

# python
alias senv="source .env/bin/activate"
alias pipi="python3 -m pip install -r req.txt"
alias djs="python3 manage.py runserver"

##### ALIAS MASTER FILE ######

# general
alias ebrc='nvim ~/.bashrc'
alias eba='nvim ~/.bash_aliases'
alias sbrc='source ~/.bashrc'
alias ll="eza -lha --icons --git --group-directories-first"
alias ls="eza -lh --icons --no-permissions --no-user"
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose ' # force remove directory
alias grep="/usr/bin/grep"
alias cd="z"
alias cat="bat -P"
# alias btop='btop --utf-force'
alias nv='nvim .'

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
alias gp="git pull"
alias gf="git fetch"
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
alias svenv="source venv/bin/activate"
alias pipi="python3 -m pip install -r req.txt"
alias djr="python3 manage.py runserver"
alias djmm="python3 manage.py makemigrations"
alias djm="python3 manage.py migrate"
alias py="python3"

# Network
alias wmip='ip route | grep "default"'
alias tu='sudo tailscale up'
alias td='sudo tailscale down'
alias ts='sudo tailscale status'

# Wayland use nvidia gpu for app
alias gpu="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia"

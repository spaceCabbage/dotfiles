##### ALIAS MASTER FILE ######

# general
alias ebrc='nvim ~/.bashrc'
alias eba='nvim ~/.bash_aliases'
alias sbrc='source ~/.bashrc'
alias stx="tmux source ~/.tmux.conf"

alias ll="eza -lhaF --icons --git --group-directories-first"
alias ls="eza -lhF --icons --no-permissions --no-user --color=always"
alias lc="eza -lhF --icons --no-permissions --no-user --color=always"

alias cd="z"
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose ' # force remove directory
alias :q="exit"
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

alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dcb="docker compose up --build"

# Network
alias wmip='ip route | rg "default"'

alias linutil="curl -fsSL https://christitus.com/linux | sh"

# Solomon Shortcut
alias sol='tmux has-session -t solomon 2>/dev/null || ( \
    tmux new-session -d -s solomon -n terminal && \
    tmux new-window -t solomon:2 -n dev && \
    tmux new-window -t solomon:3 -n Editor -c "$HOME/Documents/dev/solomon" && \
    tmux send-keys -t solomon:1 "clear" C-m && \
    tmux send-keys -t solomon:2 "cd $HOME/Documents/dev/solomon/client && clear" C-m && \
    tmux split-window -t solomon:2 -h -c "$HOME/Documents/dev/solomon/server" && \
    tmux select-pane -t solomon:2.1 -T client && \
    tmux select-pane -t solomon:2.2 -T server && \
    tmux send-keys -t solomon:2.2 "senv && clear" C-m && \
    tmux send-keys -t solomon:3 "clear" C-m \
); tmux select-window -t solomon:2; tmux attach -t solomon'


alias kill="tmux kill-session"

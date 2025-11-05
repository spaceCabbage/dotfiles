##### ALIAS MASTER FILE ######

# general
alias ebrc='nvim ~/.bashrc'

alias eba='nvim ~/.bash_aliases'
alias sbrc='source ~/.bashrc'
alias stx="tmux source ~/.tmux.conf"
alias ncdu="ncdu --color dark -t 10"
alias shutdown="shutdown now"
alias ts="sudo tailscale"
alias o="ollama"
alias dc="cd"
alias sl="ls"
alias ll="eza -lhaF --icons --git --group-directories-first --git-repos --git"
alias ls="eza --icons --no-permissions --no-user --color=always"
# alias ln="eza -lhF --icons --no-permissions --no-user --no-filesize --color=always -s modified -r"
# alias cd="z"
alias bd='cd "$OLDPWD"'
alias rmd='/bin/rm  --recursive --force --verbose'
alias yy="yazi"
alias ox="oxker"
alias rg="rg --color=always --smart-case"
alias cat="bat -P"
alias nv='nvim .'
alias hh=hstr

# DNF
alias update='sudo dnf update -y --refresh'
alias install='sudo dnf install'

# ssh
alias moon="ssh yehuda@10.0.0.7"
alias ribis="ssh -p 2222 ribis@145.223.116.211"
alias club="ssh cork@club.corkandcellar.net -p 2222"
alias kepler="ssh -p 2222 yehuda@kepler"
alias apollo="ssh yehuda@10.0.0.39"
alias ray="ssh ray@api.rayati.date -p 2222" 
alias hubble="ssh yehuda@159.203.91.217"

# Syncing
alias syncdot='cd ~/dotfiles/ && git add . && git commit -m "Update dotfiles" && git push && bd'
alias pd='cd ~/dotfiles/ && git pull && bd'
alias sd="syncdot"

# Notes management
syncnotes() {
    local notes_dir="${1:-$HOME/Documents/notes}"
    local original_dir=$(pwd)

    cd "$notes_dir" || { echo "❌ Notes directory not found"; return 1; }

    echo "🔄 Syncing notes..."

    # Fetch remote changes
    git fetch origin 2>/dev/null

    # Check if there are remote changes
    local remote_changes=$(git rev-list HEAD..@{u} --count 2>/dev/null || echo "0")

    # Check if there are local changes
    if [[ -n $(git status -s) ]]; then
        local has_local_changes="true"
    else
        local has_local_changes="false"
    fi

    # Stash local changes if needed (only if pulling remote changes)
    local stashed="false"
    if [[ "$has_local_changes" == "true" && "$remote_changes" -gt 0 ]]; then
        echo "📦 Stashing local changes..."
        git stash push -m "Auto-stash before sync $(date +%Y-%m-%d\ %H:%M:%S)" >/dev/null
        stashed="true"
    fi

    # Pull remote changes if any
    if [[ "$remote_changes" -gt 0 ]]; then
        echo "⬇️  Pulling $remote_changes remote change(s)..."
        git pull --rebase --autostash
    else
        echo "✓ No remote changes"
    fi

    # Reapply stashed changes
    if [[ "$stashed" == "true" ]]; then
        echo "📂 Reapplying local changes..."
        git stash pop >/dev/null
    fi

    # Commit any local changes (including those from stash)
    if [[ -n $(git status -s) ]]; then
        echo "💾 Committing local changes..."
        git add -A
        git commit -m "Notes update $(date +%Y-%m-%d\ %H:%M:%S)" >/dev/null
    else
        echo "✓ No local changes to commit"
    fi

    # Push everything
    local commits_to_push=$(git rev-list @{u}..HEAD --count 2>/dev/null || echo "0")
    if [[ "$commits_to_push" -gt 0 ]]; then
        echo "⬆️  Pushing $commits_to_push commit(s)..."
        git push
    else
        echo "✓ Nothing to push"
    fi

    echo "✅ Sync complete!"
    cd "$original_dir"
}

alias sn="syncnotes"
alias notes='glow ~/Documents/notes'
alias n="notes"

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

# Network
alias wmip='ip route | rg "default"'

alias linutil="curl -fsSL https://christitus.com/linux | sh"

alias kill="tmux kill-session"

# pacman package installer with fzf
yayi() {
  fzf_args=(
    --multi
    --preview 'pacman -Sii {1}'
    --preview-label='alt-p: toggle description, alt-j/k: scroll, tab: multi-select, F11: maximize'
    --preview-label-pos='bottom'
    --preview-window 'down:45%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
    --color 'pointer:green,marker:green'
  )

  pkg_names=$(pacman -Slq | fzf "${fzf_args[@]}")

  if [[ -n "$pkg_names" ]]; then
    # Convert newline-separated selections to space-separated for pacman
    echo "$pkg_names" | tr '\n' ' ' | xargs sudo pacman -S --noconfirm
  fi

}

alias claude="~/.claude/local/claude"

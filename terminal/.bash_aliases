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
alias cdr='cd "$(git rev-parse --show-toplevel)"'
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
alias m="make"
alias zed='zeditor'

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
alias symp="ssh -p 2222 deploy@symphony.amberlogic.com"
alias football="ssh yehuda@football.local"
alias ime="ssh -p 2222 deploy@ime.amberlogic.com"
alias lucy="ssh -p 2222 lucy@lucyconway.blog"

# Syncing
sync_repo() {
    local repo_dir="${1:-.}"
    local commit_msg="${2:-Update $(basename "$repo_dir") - $(date +%Y-%m-%d\ %H:%M:%S)}"
    local original_dir=$(pwd)

    cd "$repo_dir" || { echo "Directory not found: $repo_dir"; return 1; }

    echo "Syncing $(basename "$repo_dir")..."

    git fetch origin 2>/dev/null

    local remote_changes=$(git rev-list HEAD..@{u} --count 2>/dev/null || echo "0")
    local has_local_changes="false"
    [[ -n $(git status -s) ]] && has_local_changes="true"

    local stashed="false"
    if [[ "$has_local_changes" == "true" && "$remote_changes" -gt 0 ]]; then
        echo "Stashing local changes..."
        git stash push -m "Auto-stash before sync $(date +%Y-%m-%d\ %H:%M:%S)" >/dev/null 2>&1
        stashed="true"
    fi

    if [[ "$remote_changes" -gt 0 ]]; then
        echo "Pulling $remote_changes remote change(s)..."
        git pull --rebase --autostash 2>/dev/null || git pull 2>/dev/null
    else
        echo "No remote changes"
    fi

    if [[ "$stashed" == "true" ]]; then
        echo "Reapplying local changes..."
        git stash pop >/dev/null 2>&1
    fi

    if [[ -n $(git status -s) ]]; then
        echo "Committing local changes..."
        git add -A
        git commit -m "$commit_msg" >/dev/null 2>&1
    else
        echo "No local changes to commit"
    fi

    local commits_to_push=$(git rev-list @{u}..HEAD --count 2>/dev/null || echo "0")
    if [[ "$commits_to_push" -gt 0 ]]; then
        echo "Pushing $commits_to_push commit(s)..."
        git push 2>/dev/null
    else
        echo "Nothing to push"
    fi

    echo "Sync complete!"
    cd "$original_dir"
}

syncdot() {
    sync_repo "$HOME/dotfiles" "Update dotfiles"
}

alias pd='cd ~/dotfiles/ && git pull && bd'
alias sd="syncdot"

# Notes management
NOTES_DIR="$HOME/Documents/notes"

syncnotes() {
    sync_repo "$NOTES_DIR" "Notes update"
}

notes() {
    if [[ -n "$1" ]]; then
        # Create/edit note
        local note_name="$1"
        local note_path

        # Add .md extension if not present
        [[ "$note_name" != *.md ]] && note_name="${note_name}.md"
        note_path="$NOTES_DIR/$note_name"

        # Create parent directories if needed
        mkdir -p "$(dirname "$note_path")"

        # Create note with template if it doesn't exist
        if [[ ! -f "$note_path" ]]; then
            cat > "$note_path" << EOF
# ${note_name%.md}

Created: $(date '+%Y-%m-%d %H:%M')

---

EOF
        fi

        ${EDITOR:-nvim} "$note_path"
    else
        # Browse all notes
        glow -p -w 120 "$NOTES_DIR"
    fi
}

fn() {
    local selected
    selected=$(find "$NOTES_DIR" -type f \( -name "*.md" -o -name "*.txt" \) 2>/dev/null |
        sed "s|$NOTES_DIR/||" |
        fzf --preview "glow $NOTES_DIR/{}" \
            --preview-window="right:70%:wrap" \
            --bind 'alt-p:toggle-preview' \
            --bind 'alt-j:preview-down,alt-k:preview-up' \
            --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
            --header 'alt-p: toggle preview | alt-j/k: scroll | enter: open' \
            --color 'fg:#ebdbb2,bg:#282828,hl:#fe8019,fg+:#fbf1c7,bg+:#3c3836,hl+:#fabd2f,info:#83a598,prompt:#b8bb26,pointer:#8ec07c,marker:#8ec07c,spinner:#d3869b,header:#928374')

    [[ -n "$selected" ]] && glow -p "$NOTES_DIR/$selected"
}

alias sn="syncnotes"
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

cheat() {
  echo "!!  Last command"
  echo "!$  Last arg"
  echo "!^  First arg"
  echo "!*  All args"
}

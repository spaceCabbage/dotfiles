##### Useful functions that require more than an alias

##### fzf
# Kill process
function fzf-kill-process() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Searech Man Pages
# Man without options will use fzf to select a page
function fzf-man() {
  MAN="/usr/bin/man"
  if [ -n "$1" ]; then
    $MAN "$@"
    return $?
  else
    $MAN -k . | fzf --reverse --preview="echo {1,2} | sed 's/ (/./' | sed -E 's/\)\s*$//' | xargs $MAN" | awk '{print $1 "." $2}' | tr -d '()' | xargs -r $MAN
    return $?
  fi
}

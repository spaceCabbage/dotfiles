#!/bin/bash
# Welcome message for login shells

# Only run on login shells
shopt -q login_shell || return 0

# Skip in automated/non-human terminals (Claude Code, dumb terminals, Emacs)
[[ -n "$CLAUDE_CODE" || "$TERM" == "dumb" || -n "$INSIDE_EMACS" ]] && return 0

# Colors
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# Helper for box lines (pads to fixed width)
_box() { printf "${GRAY}│${NC}  %-36s${GRAY}│${NC}\n" "$1"; }

# Gather info (all instant, fail silently)
_date=$(date "+%a %b %d, %I:%M %p" 2>/dev/null)
_local_ip=$(hostname -I 2>/dev/null | awk '{print $1}')
_tailscale_ip=$(tailscale ip -4 2>/dev/null)
_exit_node=$(tailscale status 2>/dev/null | awk '/; exit node;/{print $2}')
_pub_loc=$(timeout 1 curl -s ipinfo.io 2>/dev/null | grep -oP '"city": "\K[^"]+|"country": "\K[^"]+' | paste -sd ', ')

if [[ -n "$SSH_CONNECTION" ]]; then
    # SSH session - show detailed box
    _ssh_from=$(echo "$SSH_CONNECTION" | awk '{print $1}')

    # Detect if SSH is via Tailscale (100.x.x.x range)
    if [[ "$_ssh_from" == 100.* ]]; then
        _conn_type="Tailscale"
    else
        _conn_type="Network"
    fi

    echo -e "${GRAY}┌──────────────────────────────────────┐${NC}"
    _box "$_date"
    _box ""
    _box "SSH via: $_conn_type ($_ssh_from)"
    [[ -n "$_local_ip" ]] && _box "Local IP: $_local_ip"
    [[ -n "$_tailscale_ip" ]] && _box "Tailscale: $_tailscale_ip"
    [[ -n "$_exit_node" ]] && _box "Exit node: $_exit_node"
    [[ -n "$_pub_loc" ]] && _box "Location: $_pub_loc"
    echo -e "${GRAY}└──────────────────────────────────────┘${NC}"
else
    # Local session - simple one-liner
    _parts=("$_date")
    [[ -n "$_local_ip" ]] && _parts+=("$_local_ip")
    [[ -n "$_pub_loc" ]] && _parts+=("$_pub_loc")

    echo -e "${CYAN}$(IFS=' | '; echo "${_parts[*]}")${NC}"
fi

# Cleanup
unset _date _local_ip _tailscale_ip _exit_node _pub_loc _ssh_from _conn_type _parts _box

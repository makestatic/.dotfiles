#!/usr/bin/env bash

# Directories to search (absolute paths, no ~ expansion issues)
search_dirs=(
    "$HOME/github"
    "$HOME/prog"
    "$HOME/personal"
)

# Keep only existing dirs
existing_dirs=()
for dir in "${search_dirs[@]}"; do
    if [[ -d $dir ]]; then
        existing_dirs+=("$dir")
    fi
done

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Search from home dirs, ignoring hidden dirs
    selected=$(find "${existing_dirs[@]}" -mindepth 1 -maxdepth 4 -type d 2>/dev/null \
        | grep -v '/\.' \
        | fzf)
fi

# If nothing chosen, bail out
[[ -z $selected ]] && exit 0

# Session name = dir basename, dots replaced with underscores
selected_name=$(basename "$selected" | tr . _)

# Start tmux session if not running
tmux_running=$(pgrep tmux)
if [[ -z $TMUX && -z $tmux_running ]]; then
    exec tmux new-session -s "$selected_name" -c "$selected"
fi

# Create session if missing
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

# Switch to session
tmux switch-client -t "$selected_name"

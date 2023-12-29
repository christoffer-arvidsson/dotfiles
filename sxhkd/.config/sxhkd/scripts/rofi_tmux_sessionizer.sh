#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ ~/projects ~/repos ~/work -mindepth 1 -maxdepth 2 -type d -not -path '*/[@.]*' | rofi -dmenu -p "Select directory for tmux session")
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

kitty -e tmux new-session -A -s $selected_name -c $selected

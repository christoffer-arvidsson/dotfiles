#!/usr/bin/env bash

# Read open tmux sessions and generate a list of session names
sessions=$(tmux list-sessions -F "#S" 2>/dev/null)

# Launch Rofi and prompt the user to select a session
selected_session=$(echo "$sessions" | rofi -dmenu -p "Select a tmux session")

# Check if the user selected a session
if [[ -n "$selected_session" ]]; then
  # Attach to the selected tmux session in a new terminal window
  kitty -e tmux new-session -A -t "$selected_session" &
fi

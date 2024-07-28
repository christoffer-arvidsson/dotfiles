#!/usr/bin/env bash

# Script for launching an emacs client in a fuzzy found directory.
# The client will launch `dired`.
#
# The workflow this achieves is to quickly open emacs in specific project
# directories, similar to how one would work with tmux.

if [[ $# -eq 1 ]]; then
    selected=$1
else

    selected=$(find ~/.dotfiles ~/.config ~/projects ~/Dropbox/org ~/repos ~/work -mindepth 0 -maxdepth 1 -type d | rofi -dmenu -p "Select directory")
fi

if [[ -z $selected ]]; then
    exit 0
fi

emacsclient -s null -c --eval "(dired \"$selected\")"

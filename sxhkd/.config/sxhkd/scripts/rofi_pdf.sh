#!/usr/bin/env bash

# Simple script to open a pdf in a list of directories.
DIRECTORIES=("$HOME/Zotero/" "$HOME/Downloads" "$HOME/Documents", "$HOME/Dropbox/books")

find_pdfs() {
    find ${DIRECTORIES[@]} -name "*.pdf"
}

SELECTED=$(find_pdfs | rofi -i -dmenu -p "Select a pdf")

if [[ -n "$SELECTED" ]]; then
    zathura "$SELECTED"
fi

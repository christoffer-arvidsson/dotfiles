#!/usr/bin/env bash

xdg_config_home=${XDG_CONFIG_HOME:-~/.config}
profiles_dir="$xdg_config_home/qutebrowser/profiles/"
qb_config="$xdg_config_home/qutebrowser/config.py"

mkdir -p $profiles_dir/default

function get_profiles() {
    find "$profiles_dir" -mindepth 1 -maxdepth 1 -type d
}

function select_profile() {
    rofi -dmenu -no-custom -i -p "Select qutebrowser session" $1
}

selected=`get_profiles | select_profile`

if [[ -n "$selected" ]]; then
    qutebrowser -B $selected -C $qb_config &
fi

#!/usr/bin/env bash

name="$1"
filename=/tmp/"$1"

bspc_write_nodeid() {
    while true
    do
        flag=false
        for id in $(bspc query -d focused -N -n .floating.sticky.hidden)
        do
            bspc query --node $id -T | grep -q $name && { echo $id > $filename; flag=true; break; }
        done
        [[ "$flag" == "true" ]] && break
        sleep 0.1s
    done
}

hide_all_except_current(){
    for id in $(bspc query -d focused -N -n .floating.sticky.!hidden)
    do
        bspc query --node $id -T | grep -qv $name && bspc node $id --flag hidden=on
    done
}

toggle_hidden() {
    [ -e "$filename" ] || exit 1
    hide_all_except_current
    id=$(<$filename)

    # Move window to current desktop
    current_desktop=$(bspc query -D -d focused)
    bspc node "$id" --to-desktop "$current_desktop"

    # Show (toggle hidden) and focus
    bspc node "$id" --flag hidden -f
}

create_terminal(){
    alacritty --class="$name","$name" -e tmux new-session -A -s $1 "$1" &
}

if ! ps -ef | grep -q "[c]lass=$name"
then
    bspc rule -a "$name" --one-shot state=floating sticky=on hidden=on center=true rectangle=1600x900+0+0
    case "$name" in
        "htop")
            create_terminal htop
            ;;
        "terminal")
            create_terminal $SHELL
            ;;
        "ranger")
            create_terminal ranger
            ;;
        "pulsemixer")
            create_terminal pulsemixer
            ;;
        *)
            exit 1
    esac
    bspc_write_nodeid
    toggle_hidden
else
    toggle_hidden
fi

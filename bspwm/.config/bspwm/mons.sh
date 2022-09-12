#!/bin/bash

# Layouts:
# 1 monitor: p
# 2 monitor: p e1
# 3 monitor: p e1 e2

# TODO: Consider that e1 might have to be right of e2 sometimes

PRIMARY_MONITOR=$(xrandr | grep " connected primary" | awk '{ print $1 }')
EXTERNAL_MONITORS=($(xrandr -q | grep " connected" | grep -v "primary" | awk '{ print $1 }'))

function get_num_monitors {
    xrandr | grep ' connected' | wc -l
}

function get_monitor_resolution {
    xrandr --query | grep -A 1 $1 | grep -v connected | awk '{ print $1 }'
}

# # Startup setup
function startup() {
    nvidia-settings --assign "CurrentMetaMode=$PRIMARY_MONITOR: nvidia-auto-select"
    bspc monitor "%$PRIMARY_MONITOR" -d 1 2 3 4 5 6 7 8 9 10
}

function monitor_add() {
    # move workspaces
    to_move=${@:2}
    for desktop in $to_move; do
        echo $desktop
        bspc desktop "$desktop" --to-monitor "%$1"
    done

    # remove default desktop
    bspc desktop Desktop --remove

    # Reorder
    bspc wm -O "$1" "%$PRIMARY_MONITOR"
}

function monitor_remove() {
    # add temp desktop
    bspc monitor "$1" -a Desktop

    # move all workspaces to primary
    for desktop in $(bspc query -D -m "$1"); do
        bspc desktop "$desktop" --to-monitor "%$PRIMARY_MONITOR"
    done

    bspc desktop Desktop --remove
}

function dock() {
    # desktop distributions
    n_monitors=$(get_num_monitors)
    echo "Docking with $n_monitors monitors"

    case $n_monitors in
        2)
            prim="6 7 8 9 10"
            per_ext=("1 2 3 4 5")
            ;;
        3)
            prim="9 10"
            per_ext=("1 2 3 4" "5 6 7 8")
            ;;
    esac

    # Move desktops to externals
    for i in ${!EXTERNAL_MONITORS[@]}; do
        monitor_add ${EXTERNAL_MONITORS[$i]} ${per_ext[$i]}
    done
}

function undock() {
    echo "Undocking"
    for i in ${!EXTERNAL_MONITORS[@]}; do
        monitor_remove ${EXTERNAL_MONITORS[$i]}
    done

    # reorder
    bspc monitor "%$PRIMARY_MONITOR" -o 1 2 3 4 5 6 7 8 9 10
}

function nvidia_command() {
    monitor=$1
    res=$(get_monitor_resolution $monitor)

    echo "$monitor: nvidia-auto-select @${res}${2} {ViewPortIn=$res, ViewPortOut=$res+0+0, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
}

function assemble_nvidia_command() {
    cmd="nvidia-settings --assign \"CurrentMetaMode="

    n_monitors=$(get_num_monitors)
    case $n_monitors in
        1)
            cmd="$cmd$(nvidia_command $PRIMARY_MONITOR '+0+0')"
            ;;
        2)
            # Primary is below external
            cmd="$cmd$(nvidia_command $PRIMARY_MONITOR '+320+1440')"
            offsets=("+0+0")
            ;;
        3)
            # horizontal layout
            cmd="$cmd$(nvidia_command $PRIMARY_MONITOR '+0+0')"
            offsets=("+1920+0" "+3840+0")
            ;;
    esac

    for i in ${!EXTERNAL_MONITORS[@]}; do
        cmd="$cmd, $(nvidia_command ${EXTERNAL_MONITORS[$i]} ${offsets[$i]})"
    done

    cmd="$cmd\""

    echo "$cmd"
}

function main() {
    if [[ "$1" = 0 ]]; then
        startup
        sleep 1
    fi

    n_monitors=$(get_num_monitors)
    echo "Num monitors: $n_monitors"
    echo "Found primary monitor: $PRIMARY_MONITOR $(get_monitor_resolution $PRIMARY_MONITOR)"
    echo "Externals: ${EXTERNAL_MONITORS[*]}"

    cmd=$(assemble_nvidia_command)
    eval $cmd

    case $n_monitors in
        1) undock ;;
        *) dock ;;
    esac

    feh --bg-scale ~/.dotfiles/.img/space.jpg 
    ~/.config/polybar/scripts/launch.sh
}

main $1


#!/usr/bin/env bash

move_desktops() {
  from=$1
  to=$2
  bspc monitor $1 -a temp # add temp desktop so we can move the others
  for d in $(bspc query -m $1 -D); do
      bspc desktop $d --to-monitor $2;
  done
  bspc monitor $1 --remove # remove old desktop
  # bspc desktop Desktop --remove > /dev/null # remove bspwms default Desktop
}

monitorlist=($(xrandr | grep ' connected' | awk '{print $1}'))
primary=$(xrandr | grep ' connected primary' | awk '{print $1}')
n_monitors=${#monitorlist[@]}

declare -A layouts=(
    [1]="web code opt1 opt2 opt3 opt4 opt5 opt6 msg music"
    [2]="web code opt1 opt2 msg music;opt3 opt4 opt5 opt6"
    [3]="web code opt1 opt2 msg music;opt3 opt4;opt5 opt6"
)

# Move all desktops to primary
for monitor in ${monitorlist[@]}; do
    if [[ $monitor != $primary ]]
    then
        move_desktops $monitor $primary
    fi
done

# Distribute according to layout setup
count=1
for ((i=0; i<$n_monitors; i++ )); do
    monitor=${monitorlist[$i]}
    IFS=';' read -ra layout <<< ${layouts[$n_monitors]}
    if [[ $monitor != $primary ]]
    then
        workspaces=${layout[count]}

        IFS=' ' read -ra workspaces <<< $workspaces

        for d in ${workspaces[@]}; do
            bspc desktop $d --to-monitor $monitor
        done

        let count++
    fi
done


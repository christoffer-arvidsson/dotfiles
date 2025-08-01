#!/usr/bin/env bash

# Pascal Jaeger <pascal.jaeger@leimstift.de>

# utils
green="\033[0;32m"
red="\033[0;31m"
blue="\033[0;34m"
nocolor="\033[0m"

#util functions
check() {
	command -v "$1" 1>/dev/null
}

ok() {
	echo -e "[$green  $nocolor] $*"
}

err() {
	echo -e "[$red  $nocolor] $*"
}
optional() {
	echo -e "[$blue  $nocolor] $*"
}

notify() {
	# shellcheck disable=SC2015
	check notify-send && {
		notify-send "$@"
	} || {
		echo "$@"
	}
}

checkUtils() {
	# shellcheck disable=SC2015
	check grep && ok "grep" || err "grep"
	# shellcheck disable=SC2015
	check grep && ok "cut" || err "cut"
	# shellcheck disable=SC2015
	check notify-send && ok "notify-send (Optional)" || optional "notify-send (Optional)"
	exit
}

basicChecks() {
	check hyprctl || {
		notify "Seriously mate!!" "Start Hyprland before this script"
		exit 1
	}
	# pgrep -x Hyprland &>/dev/null || {
	# 	notify "Make Sure Hyprland Session is running."
	# 	exit 1
	# }
}

help() {
	cat <<EOF
  This is a bash script to move arbitrary workspace to arbritrary monitor and to swap workspaces between
  monitors if the desired workspace is already active on a monitor for Hyprland using hyprctl.

  flags:
    -h: Displays This help menu
    -c: Checks for all dependencies

  Usage: try_swap_workspace [WORKSPACE]
    bind = ALT,1,exec, /path/to/try_swap_workspace/binary 1
    (where the last 1 is the workspace that should be shown on the currently active monitor)

EOF
}

getArgs() {
	while [ "$#" -gt 0 ]; do
		case "$1" in
		-h | --help)
			help
			exit 0
			;;
		-c)
			checkUtils
			;;
    (*[!0-9]*)
      # contains non-numbers
      help
      echo ""
      echo "Wrong argument given"
      exit 1
      ;;
    *)
      # only nubers left, so good
      switch_or_swap "$1"
      ;;
    esac
    shift
  done
}


#variables
mon_wrkspcs=()

get_active_mon() {
  echo $(($(hyprctl monitors | grep 'focused' | grep -n 'yes' | cut -c1)-1))
}

get_workspaces_array() {
  local workspaces
  workspaces=$(hyprctl monitors | grep 'active workspace' | cut -f3 -d' ')
  SAVEIFS=$IFS
  IFS=$'\n'
  mon_wrkspcs=($workspaces)
  IFS=$SAVEIFS
}

# first argument: workspace to switch to
# second argument: monitor to switch workspace on
switch_workspace() {
  local target_wrkspc=$1
  local target_mon=$2
  hyprctl dispatch moveworkspacetomonitor "$target_wrkspc" "$target_mon"
  hyprctl dispatch workspace "$target_wrkspc"
}
# first argument: monitor the workspace should go to
# second argument: monitor the workspace is currently displayed on
swap_workspace() {
  local target_mon=$1
  local source_mon=$2
  hyprctl dispatch swapactiveworkspaces "$target_mon" "$source_mon"
}

# first argument: workspace to switch to active monitor
switch_or_swap() {
  target_mon=$(get_active_mon)
  target_wrkspc=$1
  get_workspaces_array
  # check if the workspace is currently displayed on another monitor
  local currently_active_on_mon=-1
  for (( i=0; i<${#mon_wrkspcs[@]}; i++ ))
  do
    if [[ "$target_wrkspc" == "${mon_wrkspcs[$i]}" ]]; then
      currently_active_on_mon=$i
    fi
  done
  if [[ $currently_active_on_mon -lt 0 ]]; then
    # workspace is not active on any monitor, do a normal switch
    ok "switching workspace $target_wrkspc to monitor $target_mon"
    switch_workspace "$target_wrkspc" "$target_mon"
  else
    # workspace is already active on other monitor, swap workspaces between monitor
    ok "swapping workspaces between $target_mon to monitor $currently_active_on_mon"
    swap_workspace "$target_mon" "$currently_active_on_mon"
  fi
}

main() {
  basicChecks
  getArgs "$@"
}

main "$@"

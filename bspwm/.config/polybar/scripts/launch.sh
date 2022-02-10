#!/usr/bin/env bash

# notify-send -u low "autorandr: restarting polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null
do
    sleep 1
done

# determine if this is a laptop
# acpi | grep Battery > /dev/null 2> /dev/null
# is_laptop=$?

xrandr | grep ' connected' | while read -r line
do
    if [[ $line = *' primary '* ]]
    then
        # if [ $is_laptop -eq 0 ]
        # then
        #     bar="laptop-main"
        # else
        #     bar="main"
        # fi

        bar="work-topbar"
        workspace="web code opt1 opt2 opt3 opt4 opt5 opt6 msg music"
    else
        bar="external"
        workspace="ext1 ext2 ext3 ext4 ext5"
    fi

    name=$(echo $line | awk '{print $1}')
    # resolution=$(echo $line | awk '{print $4}') 
    
    bspc monitor "%$name" -d $(echo $workspace)
    sleep 0.1
    MONITOR="$name" polybar -r "${bar}" &
done

echo "Bars launched..."

# notify-send -u low "autorandr: restarted polybar"

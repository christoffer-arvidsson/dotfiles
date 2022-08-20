#!/usr/bin/env bash

# notify-send -u low "autorandr: restarting polybar"

killall polybar

# Wait until the processes have been shut down
# while pgrep -u $UID -x polybar >/dev/null
# do
#     sleep 0.1
# done

# determine if this is a laptop
acpi | grep Battery > /dev/null 2> /dev/null
is_laptop=$?

xrandr | grep ' connected' | while read -r line
do
    if [[ $line = *' primary '* ]]
    then
        if [ $is_laptop -eq 0 ]
        then
            bar="work-topbar"
        else
            bar="station-topbar"
        fi

        workspace="web code opt1 opt2 opt3 opt4 opt5 opt6 msg music"
    else
        bar="external"
        workspace="ext1 ext2 ext3 ext4 ext5"
    fi

    name=$(echo $line | awk '{print $1}')
    
    bspc monitor "%$name" -d $(echo $workspace)

    # Give bspwm time to set the monitors
    MONITOR="$name" polybar -r "${bar}" > /tmp/polybar.log 2>&1 &
done

echo "Bars launched..."

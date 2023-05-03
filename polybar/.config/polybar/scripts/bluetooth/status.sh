#!/bin/sh

name=`bluetoothctl info | grep "Name" | sed 's/^.*: //'`
onoff=`bluetoothctl show | grep "Powered" | sed 's/^.*: //'`
MAC=`bluetoothctl info | awk '/^Device/ {print $2}')`

if [ $onoff = "yes" ]
then
    if [ ! "$name" ]
    then
        echo "on"
    else
        # level=`~/.config/polybar/scripts/bluetooth/battery_level/bluetooth_battery.py $MAC` &&
        # level=`echo ${level} | awk '{print $6}'` &&
        echo "${name}"
    fi
else
    echo ""
fi

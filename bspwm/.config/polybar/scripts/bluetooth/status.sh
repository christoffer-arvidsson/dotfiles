#!/bin/sh

name=`bluetoothctl info | grep "Name" | sed 's/^.*: //'`
onoff=`bluetoothctl show | grep "Powered" | sed 's/^.*: //'`
if [ $onoff = "yes" ]
then
    if [ ! "$name" ]
    then
        echo "%{F#ff95b4e6}on"
    else
        echo "%{F#ff95b4e6}${name}"
    fi
else
    echo ""
fi

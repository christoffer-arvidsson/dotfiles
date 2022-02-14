#!/bin/sh

paired=`bluetoothctl paired-devices | grep "WH"`
controllers=`bluetoothctl list`
read -ra DEV <<< "$paired"
read -ra CON <<< "$controllers"

name=`bluetoothctl info ${ARR[1]}| grep "Name" | sed 's/^.*: //'`
onoff=`bluetoothctl show | grep "Powered" | sed 's/^.*: //'`
connected=`bluetoothctl info | grep "Connected" | sed 's/^.*: //'`


if [ $onoff == "no" ]
then
    bluetoothctl power on
fi

if [ "$connected" == "yes" ]
then
    bluetoothctl disconnect
else
    bluetoothctl connect ${DEV[1]}
    echo ${DEV[1]}
    # Sleep due to low energy devices requiring me to connect twice???
    sleep 2.5
    bluetoothctl connect ${DEV[1]}
    echo ${DEV[1]}
fi

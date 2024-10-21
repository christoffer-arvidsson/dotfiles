#!/usr/bin/env bash

VPN=$1

if [ -z "$VPN" ]
then
    exit 1
fi

ACTIVE=`nmcli con show --active | grep "$VPN"`

if [ -z "$ACTIVE" ]
then
    password=$(zenity --password --title="Enter VPN password")
    # If the user cancels or enters an empty password, exit
    if [ -z "$password" ]
    then
        exit 1
    fi

    echo $password | nmcli con up id "$VPN" --ask

else
    nmcli con down id "$VPN"
fi

exit 0

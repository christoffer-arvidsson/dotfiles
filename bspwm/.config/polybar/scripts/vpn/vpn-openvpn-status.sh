#!/bin/sh


IFACE=$(ip addr | grep wg-mullvad: | awk '{print $2}')

if [ "$IFACE" = "wg-mullvad:" ]; then
    echo " %{F#8fc99f} $(ip addr show wg-mullvad | grep inet | awk '{print $2}' | cut -f2 -d ':' | cut -c -13)%{u-}"
else
    echo "%{F#E75D5D} no vpn"
fi

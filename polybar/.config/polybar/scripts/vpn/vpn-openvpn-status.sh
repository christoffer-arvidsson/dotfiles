#!/bin/sh

IFACE=$(ip addr | grep ppp0: | awk '{print $2}')

if [ "$IFACE" = "ppp0:" ]; then
    echo "%{F#8fc99f} $(ip addr show $IFACE | grep "inet " | awk '{print $2}' | cut -f2 -d ':' | cut -c -13)%{u-}"
else
    echo "%{F#E75D5D} vpn"
fi

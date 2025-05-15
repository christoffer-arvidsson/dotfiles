#!/usr/bin/env sh

if [ -e /tmp/do_not_disturb_status ]
then
    echo '{"text": "on", "alt": "on", "tooltip": "Do-not-disturb is on", "class": "on", "percentage": "100"}'
else
    echo '{"text": "off", "alt": "off", "tooltip": "Do-not-disturb is off", "class": "off", "percentage": "0"}'
fi

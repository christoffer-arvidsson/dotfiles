#!/bin/sh

if [ -e /tmp/do_not_disturb_status ]
then
    echo "%{F#ffffffff}"
else
    echo "%{F#66ffffff}"
fi

#!/usr/bin/env bash
pid=`pidof dunst`
if [ -e /tmp/do_not_disturb_status ]
then
    kill -SIGUSR2 $pid
    rm /tmp/do_not_disturb_status
else
    kill -SIGUSR1 $pid
    touch /tmp/do_not_disturb_status
fi

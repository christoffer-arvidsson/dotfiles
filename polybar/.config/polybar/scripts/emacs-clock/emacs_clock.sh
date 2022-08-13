#!/bin/bash

is_running=$(ps auxw | grep "\-\-daemon=nondoom")

if [ -z "$is_running" ]; then
    echo ""
else
    underline_color="%{u#99c2ff}%{+u}"
    minutes=`emacsclient -s nondoom -e '(eethern/org-clocking-info)' -a false | cut -d '"' -f 2`

    echo "${underline_color}${minutes}"
fi



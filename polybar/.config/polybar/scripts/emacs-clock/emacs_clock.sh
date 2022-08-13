#!/bin/bash

is_running=$(ps auxw | grep "\-\-daemon=nondoom")

if [ -z "$is_running" ]; then
    echo ""
else
    minutes=`emacsclient -s nondoom -e '(eethern/org-clocking-info)' -a false | cut -d '"' -f 2`

    echo "$minutes"
fi



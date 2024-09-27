#!/usr/bin/env bash

is_running=$(ps auxw | grep "\-\-daemon=null")

if [ -z "$is_running" ]; then
    echo ""
else
    minutes=`emacsclient -s null -e '(eethern/org-clocking-info)' -a false | cut -d '"' -f 2`

    echo "$minutes"
fi

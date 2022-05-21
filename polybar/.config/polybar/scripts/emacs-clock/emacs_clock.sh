#!/bin/bash
is_running=$(emacsclient -s nondoom -a false -e 't')
underline_color="%{u#99c2ff}%{+u}"

if [ $is_running ]; then
    minutes="$(emacsclient -s nondoom -e '(eethern/org-clocking-info)' | cut -d '"' -f 2)"
else
    minutes=""
fi

echo "${underline_color}${minutes}"

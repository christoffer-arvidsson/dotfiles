#!/bin/bash
is_running=$(emacsclient -s nondoom -a false -e 't')

underline_color="%{u#99c2ff}%{+u}"

echo $is_running
if ! [$(is_running)]; then
    minutes=$(emacsclient -s nondoom -e '(org-clock-get-clocked-time)')
else
    minutes="hello"
fi

echo "${underline_color}T: ${minutes} min"

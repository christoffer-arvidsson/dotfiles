#!/bin/sh
function emacs_server_is_running()
{
    ps -ef | grep [e]macsserver > /dev/null
}

underline_color="%{u#99c2ff}%{+u}"

if ! [ emacs_server_is_running ]; then
    pomo_message=$(emacsclient -s nondoom -e '(eethern/org-pomodoro-time)' | cut -d '"' -f 2)
else
    pomo_message=""
fi

echo ${underline_color}${pomo_message}

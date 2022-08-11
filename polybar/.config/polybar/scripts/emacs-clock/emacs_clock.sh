#!/bin/bash

user=`id -u`
if test ! -e "/run/user/$user/emacs/nondoom"; then
    exit
fi

underline_color="%{u#99c2ff}%{+u}"
minutes=`emacsclient -s nondoom -e '(eethern/org-clocking-info)' -a false | cut -d '"' -f 2`

echo "${underline_color}${minutes}"


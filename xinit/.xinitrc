#!/bin/sh

# Make sure this is before the 'exec' comand or it won'b be sourced
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Set keymap for xdotool
setxkbmap $(setxkbmap -query | grep layout: | sed 's/layout: //g')

~/.fehbg &

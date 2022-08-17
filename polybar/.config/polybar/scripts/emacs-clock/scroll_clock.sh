
zscroll -l 30 \
        --delay 0.5 \
        --scroll-padding " | " \
        --match-command "`dirname $0`/emacs_clock.sh" \
        --update-check true "`dirname $0`/emacs_clock.sh" &

wait

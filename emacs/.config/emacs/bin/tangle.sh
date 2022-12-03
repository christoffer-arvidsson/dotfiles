#!/usr/bin/env bash

# This script should be used to initially tangle the emacs config for new installs.

function org_tangle () {
    emacs --batch -l org "$1" -f org-babel-tangle
}

cd ~/.emacs.nondoom || exit

org_tangle config.org

exit 0







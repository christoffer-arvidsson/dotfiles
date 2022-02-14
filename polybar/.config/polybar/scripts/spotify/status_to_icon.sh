#!/bin/bash
set -euo pipefail

function status_to_icon {
  while read -r status; do
    if [ "$status" = "Stopped" ]; then
      echo ""
    elif [ "$status" = "Paused"  ]; then
      echo ""
    else
      echo ""
    fi
  done
}

playerctl status -p spotify | status_to_icon

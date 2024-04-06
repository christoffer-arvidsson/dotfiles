#!/usr/bin/env bash

# Set the notification ID and icon
id=999
icon="/usr/share/icons/hicolor/128x128/apps/emacs.png"

# Set the notification parameters
params="-i $icon -r $id"

# Parse the command-line options (-s: name of server)
while getopts ":s:n:" opt; do
  case $opt in
    s)
      server=$OPTARG
      ;;
    n)
      name=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check if the server name was provided
if [ -z "$server" ]; then
  echo "Error: server config not provided." >&2
  exit 1
fi
if [ -z "$name" ]; then
  echo "Error: server name not provided." >&2
  exit 1
fi

# Send a notification about starting the daemon
notify-send $params "emacs ($name): launching daemon..."

# Start the Emacs daemon
emacs_output=$(emacs --init-directory $server --daemon=$name 2>&1)
exit_code=$?

# Check the output of the emacs command
if [[ $emacs_output == "emacs ($name): error: daemon is already running"* ]]; then
  # The daemon is already running, send a notification
  notify-send $params "emacs: ($name) daemon is already running"
elif [ $exit_code -eq 0 ]; then
  # The emacs command was successful, send a notification
  notify-send $params "emacs ($name): daemon launched successfully"
else
  # The emacs command failed, send a notification
  notify-send $params "emacs ($name): error launching Emacs daemon"
fi

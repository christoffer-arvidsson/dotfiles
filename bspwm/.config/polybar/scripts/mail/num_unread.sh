#!/usr/bin/env bash
set -euo pipefail

# Because gmail is weird, they serve "labels" where a mail can belong to
# multiple such labels. This query disregards certain mailboxes to not
# duplicate unread mails.
NUM_UNREAD=$(mu msgs-count --query='flag:unread AND NOT maildir:/gmail/[Gmail]/Bin AND NOT maildir:/gmail/[Gmail]/Spam AND NOT maildir:/gmail/[Gmail]/Sent Mail')

# echo "No unread mails"
if [ "$NUM_UNREAD" = "0" ]; then
    echo "%{F#55BFA89E}"
else
    echo "%{F#E75D5D} %{F#CAfff9e8}$NUM_UNREAD"
fi

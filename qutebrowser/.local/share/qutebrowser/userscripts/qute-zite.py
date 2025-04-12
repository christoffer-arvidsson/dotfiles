#!/usr/bin/env python3

from os import environ as e
import os
import subprocess

import re

FIFO = open(e["QUTE_FIFO"], "w")


def notify(message):
    print('message-info "{}"'.format(message), file=FIFO, flush=True)


def notify_error(message):
    print('message-error "{}"'.format(message), file=FIFO, flush=True)


def main():
    url = e["QUTE_URL"]
    match = re.search(r"arxiv\.org\/[^\d]*(\d+\.\d+v?\d+)", url)

    if match:
        arxiv_id = match.group(1)
    else:
        notify_error("[zite] Could not extract arxiv_id")
        exit(1)

    notify(f"[zite] Fetching {arxiv_id} and PDF...")

    cmd = ["zite", "fetch", arxiv_id, "--pdf"]
    result = subprocess.run(cmd)
    if result.returncode == 1:
        notify_error(f"[zite] Failed to fetch: {result.stderr}")
    else:
        notify(f"[zite] Fetched {arxiv_id} and PDF")


if __name__ == "__main__":
    main()

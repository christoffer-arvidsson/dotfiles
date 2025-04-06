#!/usr/bin/env python3
"""Use Rofi to search and open Zite pdfs.

Requirements:
- Python 3.7 or newer
- Rofi

"""

import os
import sys
import json
import subprocess
import shlex

HOME = os.environ["HOME"]

ZITE_DIR = os.path.join(HOME, "zite")
ZITE_INDEX = os.path.join(ZITE_DIR, "index.json")

VIEWER = "xdg-open %u"


def open_file(app, file_path, only_return_command=False):
    """Attempt to open ``file_path`` using ``app``.

    Parameters
    ----------
    app : str
        Application to open file. Should contain '%u' for where the file path
        would appear in the command. If '%u' is not provided, it is assumed
        that the file path is the last argument to the command.
    file_path : str
        Path to file to open.
    only_return_command : bool
        If True, only return the command and do not execute it. Default: False.

    Returns
    -------
    list
        Command that was run.

    """
    app_and_args = shlex.split(app)
    if "%u" not in app_and_args:
        app_and_args.append("%u")

    command = [arg if arg != "%u" else file_path for arg in app_and_args]

    if not only_return_command:
        subprocess.run(command)

    return [str(cmd_part) for cmd_part in command]


def show_error(error_msg, rofi_args=None):
    """Show ``error_msg`` as an error message in Rofi and stderr."""
    if rofi_args is None:
        rofi_args = []
    print(error_msg, file=sys.stderr)
    subprocess.run(["rofi", "-e", error_msg] + rofi_args)


def main():
    with open(ZITE_INDEX, "r") as f:
        index = json.load(f)

    item_list = [item["pdf_path"].split("/")[-1] for item in index.values()]
    items_input = "\n".join(item_list)

    rofi_command = ["rofi", "-dmenu", "-format", "i", "-p", "Open Zite PDF:"]
    rofi = subprocess.run(
        rofi_command, capture_output=True, text=True, input=items_input
    )
    selected_index = rofi.stdout.strip()
    if not selected_index:
        return

    file_to_open = list(index.values())[int(selected_index)]["pdf_path"]

    if os.path.isfile(file_to_open):
        try:
            open_file(VIEWER, file_to_open)
        except FileNotFoundError:
            viewer_command = open_file(VIEWER, file_to_open, only_return_command=True)
            viewer_command = [str(cmd_part) for cmd_part in viewer_command]
            viewer_command = " ".join(viewer_command)
            show_error(
                f"Could not run command: '{viewer_command}'\n"
                f"Make sure the viewer is installed"
            )


if __name__ == "__main__":
    main()

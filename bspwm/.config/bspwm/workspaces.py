#!/bin/python3

import os
import time
from dataclasses import dataclass
from collections import defaultdict
import subprocess
import json
from typing import Any, Dict, List

WS_ICON_MAP = defaultdict(lambda: "", {
    "1":"",    # web
    "2":"",    # code
    "3":"",    # opt1
    "4":"",    # opt2
    "5":"",    # opt3
    "6":"",    # opt4
    "7":"",    # opt5
    "8":"",    # opt6
    "9":"",    # msg
    "10":""     # music
})

SLEEP_DURATION_SECONDS = 0.1
PADDING_STRING = ' | '

def get_xresources():
    xfetch = subprocess.Popen("sh -c 'xrdb -merge ~/.Xresources && xrdb -q'", stdout=subprocess.PIPE, shell=True)
    xoutput, _ = xfetch.communicate()
    xrdb = xoutput.decode().splitlines()
    xdict = {}
    for i in xrdb:
        temp = i.split(":\t")
        xdict[temp[0]] = temp[1]

    return xdict

XRESOURCES = get_xresources()

COLOR_OCCUPIED = "CAFFF9E8"
COLOR_FOCUSED = XRESOURCES["highlight"]
COLOR_EMPTY = XRESOURCES["inactive"]
COLOR_URGENT = XRESOURCES["alert"]

@dataclass
class Workspace:
    name: str
    is_focused: bool
    is_empty: bool
    is_urgent: bool

def get_if_urgent(root):
    assert root is not None

    if root["client"] is None:
        return False

    if root["client"]["urgent"]:
        return True

    left_child = root["firstChild"]
    right_child = root["secondChild"]

    if left_child is not None:
        left_urgent = get_if_urgent(left_child)
        if left_urgent:
            return True

    if right_child is not None:
        right_urgent = get_if_urgent(right_child)
        if right_urgent:
            return True

    return False


def get_workspaces(bspwm_state: Dict[str, Any], bar_monitor_name: str) -> List[Workspace]:
    workspaces = []
    for monitor in bspwm_state["monitors"]:
        monitor_name = monitor["name"]
        focused_workspace = monitor["focusedDesktopId"]
        for workspace in monitor["desktops"]:
            workspace_name = workspace["name"]
            if workspace_name not in WS_ICON_MAP:
                continue

            workspace_id = workspace["id"]
            is_focused = workspace_id == focused_workspace and bar_monitor_name == monitor_name
            is_empty = workspace["root"] is None
            if not is_empty:
                is_urgent = get_if_urgent(workspace["root"])
            else:
                is_urgent = False

            workspaces.append(Workspace(workspace_name, is_focused, is_empty, is_urgent))

    return workspaces

def render_widget(workspaces: List[Workspace]) -> str:
    widget = ""

    first = True
    for w in workspaces:
        color=COLOR_OCCUPIED
        if w.is_urgent:
            color=COLOR_URGENT
        elif w.is_focused:
            color=COLOR_FOCUSED
        elif w.is_empty:
            color=COLOR_EMPTY

        ws_icon=WS_ICON_MAP[w.name]

        if first:
            first=False
        else:
            widget+=PADDING_STRING

        widget += f"%{{F{color}}}{ws_icon}%{{F-}}"
    return widget

def main():
    monitor = os.environ.get("MONITOR", "")

    # Continuously update the module
    while True:
        bspwm_state = json.loads(subprocess.getoutput("bspc wm -d"))
        workspaces = get_workspaces(bspwm_state, monitor)

        # Todo: support non-numeric I guess
        workspaces.sort(key=lambda w: int(w.name))

        widget = render_widget(workspaces)
        print(widget, flush=True)
        time.sleep(SLEEP_DURATION_SECONDS)



if __name__ == "__main__":
    main()

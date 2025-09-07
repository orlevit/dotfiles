#!/usr/bin/env python3
import json
import subprocess
import sys

with open("/tmp/kill.log", "a") as f:
    f.write("Script started\n")
# Get all windows in JSON format
i3_tree = subprocess.check_output(["i3-msg", "-t", "get_tree"])
i3_tree = json.loads(i3_tree)

# Get currently focused window
def find_focused(node):
    if node.get("focused"):
        return node
    for n in node.get("nodes", []) + node.get("floating_nodes", []):
        res = find_focused(n)
        if res:
            return res
    return None

focused = find_focused(i3_tree)
if not focused:
    sys.exit(0)

app_class = focused.get("window_properties", {}).get("class")
if not app_class:
    sys.exit(0)

# Collect all windows of the same class
def collect_windows(node, cls):
    windows = []
    if node.get("window_properties", {}).get("class") == cls:
        windows.append(node)
    for n in node.get("nodes", []) + node.get("floating_nodes", []):
        windows.extend(collect_windows(n, cls))
    return windows

windows = collect_windows(i3_tree, app_class)
if not windows:
    sys.exit(0)

# Find the next window in the list
focused_id = focused["id"]
window_ids = [w["id"] for w in windows]
try:
    idx = window_ids.index(focused_id)
except ValueError:
    idx = -1
next_idx = (idx + 1) % len(window_ids)
next_id = window_ids[next_idx]

# Focus next window

subprocess.call(["/usr/bin/i3-msg", "[con_id=%s] focus" % next_id])

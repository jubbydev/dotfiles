#!/usr/bin/env python3
"""Copy gh-pr's pane-level `pr` token up to the owning workspace.

gh-pr labels panes; the herdr spaces sidebar only renders workspace tokens.
Without this, `$pr` in [ui.sidebar.spaces] never resolves.
"""
import json
import subprocess
import sys
import time

SOURCE = "pr-mirror"
TOKEN = "pr"


def herdr(*args):
    out = subprocess.run(["herdr", *args], capture_output=True, text=True, timeout=15)
    if out.returncode != 0:
        return None
    try:
        return json.loads(out.stdout)["result"]
    except (ValueError, KeyError):
        return None


def main():
    if "--refresh" in sys.argv:
        # gh-pr's action returns as soon as its command is spawned, so give it a
        # moment to land its pane token before we read it.
        # ponytail: fixed wait, poll the token if this ever feels laggy.
        herdr("plugin", "action", "invoke", "gh-pr.refresh")
        time.sleep(3)

    panes = herdr("pane", "list")
    spaces = herdr("workspace", "list")
    if panes is None or spaces is None:
        return

    # Several panes can share a workspace and branch. They agree, so last wins;
    # panes with no PR contribute nothing rather than blanking the row.
    wanted = {}
    for pane in panes["panes"]:
        label = (pane.get("tokens") or {}).get(TOKEN)
        if label:
            wanted[pane["workspace_id"]] = label

    for space in spaces["workspaces"]:
        wid = space["workspace_id"]
        current = (space.get("tokens") or {}).get(TOKEN)
        target = wanted.get(wid)
        if target == current:
            continue
        if target:
            herdr("workspace", "report-metadata", wid,
                  "--source", SOURCE, "--token", f"{TOKEN}={target}")
        else:
            herdr("workspace", "report-metadata", wid,
                  "--source", SOURCE, "--clear-token", TOKEN)


if __name__ == "__main__":
    main()

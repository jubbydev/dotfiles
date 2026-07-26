#!/usr/bin/env python3
"""Remove a worktree workspace, including the state herdr can't recover from.

`herdr worktree remove` shells out to `git worktree remove`. Dev tooling leaves
gitignored artifacts behind (.vite, .wt-supabase), so git deregisters the
worktree but the directory survives. Every retry then fails with "is not a
working tree" and herdr treats that as fatal, so the workspace is stuck in the
sidebar forever.

This tries the normal path first and only takes over on that specific failure.
"""
import json
import os
import shutil
import subprocess
import sys

WORKTREE_ROOT = os.path.expanduser("~/.herdr/worktrees")
# Directory names safe to delete on sight: build caches and installed deps, all
# regenerable. Anything else means real files survived and we stop.
REGENERABLE = {"node_modules", "dist", "build", "coverage"}


def herdr(*args):
    out = subprocess.run(["herdr", *args], capture_output=True, text=True, timeout=30)
    try:
        payload = json.loads(out.stdout)
    except ValueError:
        return None, out.stderr.strip() or "herdr produced no parseable output"
    if "error" in payload:
        return None, payload["error"].get("message", "unknown error")
    return payload.get("result"), None


def notify(title, body=""):
    subprocess.run(["herdr", "notification", "show", title, "--body", body],
                   capture_output=True, timeout=10)


def leftovers_are_safe(path):
    """True when every top-level entry is a dotfile or a known build artifact."""
    for name in os.listdir(path):
        if not name.startswith(".") and name not in REGENERABLE:
            return False, name
    return True, None


def main():
    ctx = json.loads(os.environ.get("HERDR_PLUGIN_CONTEXT_JSON") or "{}")
    wid = (sys.argv[1] if len(sys.argv) > 1 else None) or ctx.get("workspace_id")
    if not wid:
        notify("Remove worktree", "No workspace in context")
        return 1

    info, err = herdr("workspace", "get", wid)
    if err:
        notify("Remove worktree failed", err)
        return 1
    space = info["workspace"]
    tree = space.get("worktree") or {}
    path, repo_root = tree.get("checkout_path"), tree.get("repo_root")
    label = space.get("label", wid)

    if not path:
        notify("Not a worktree", f"{label} is a plain workspace; use close instead")
        return 1

    _, err = herdr("worktree", "remove", "--workspace", wid)
    if not err:
        notify("Worktree removed", label)
        return 0

    # Only the orphaned case is ours to handle. A dirty or in-use worktree must
    # keep failing loudly rather than get force-deleted behind the user's back.
    if "is not a working tree" not in err:
        notify("Remove worktree failed", err)
        return 1

    if os.path.exists(path):
        if not os.path.realpath(path).startswith(os.path.realpath(WORKTREE_ROOT) + os.sep):
            notify("Refusing to delete", f"{path} is outside {WORKTREE_ROOT}")
            return 1
        # If git can still see it, it isn't orphaned and this is not our case.
        if subprocess.run(["git", "-C", path, "rev-parse", "--git-dir"],
                          capture_output=True).returncode == 0:
            notify("Refusing to delete", f"{path} is still a live git worktree")
            return 1
        safe, offender = leftovers_are_safe(path)
        if not safe:
            notify("Worktree not empty", f"{label} still holds '{offender}' — inspect it by hand")
            return 1
        shutil.rmtree(path)

    _, err = herdr("workspace", "close", wid)
    if err:
        notify("Closed dir but not workspace", err)
        return 1

    if repo_root:
        subprocess.run(["git", "-C", repo_root, "worktree", "prune"],
                       capture_output=True, timeout=30)

    notify("Worktree removed", f"{label} (recovered from orphaned checkout)")
    return 0


if __name__ == "__main__":
    sys.exit(main())

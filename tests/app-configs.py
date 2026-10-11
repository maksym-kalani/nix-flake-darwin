"""Check the Home Manager config sources without starting either app."""

import json
from pathlib import Path
import sys
import tomllib


theme_path, aerospace_path = map(Path, sys.argv[1:])
theme = json.loads(theme_path.read_text(encoding="utf-8"))
with aerospace_path.open("rb") as source:
    aerospace = tomllib.load(source)

assert theme["version"] == 4
assert theme["transient_prompt"]["template"] == "❯ "
assert theme["transient_prompt"]["foreground"] == "#e4bad9"
assert [block["type"] for block in theme["blocks"]] == ["prompt", "rprompt", "prompt"]
assert [segment["type"] for segment in theme["blocks"][0]["segments"]] == [
    "session", "path", "git"
]
assert theme["blocks"][0]["segments"][2]["options"]["fetch_status"] is True
assert theme["blocks"][1]["segments"][0]["options"]["threshold"] == 500
assert theme["blocks"][2]["segments"][0]["type"] == "status"

assert aerospace["start-at-login"] is True
assert aerospace["exec"]["inherit-env-vars"] is True
assert aerospace["exec"]["env-vars"]["PATH"].startswith("${HOME}/.nix-profile/bin:")
startup = aerospace["after-startup-command"]
assert "exec-and-forget sketchybar" in startup
assert any(command.startswith("exec-and-forget borders ") for command in startup)
workspace_hook = aerospace["exec-on-workspace-change"]
assert workspace_hook[:2] == ["/bin/bash", "-c"]
assert workspace_hook[2] == (
    "sketchybar --trigger aerospace_workspace_change "
    "FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE "
    "PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE"
)

assert "workspace-to-monitor-force-assignment" not in aerospace
assert aerospace["gaps"]["outer"]["top"] == 55
bindings = aerospace["mode"]["main"]["binding"]
for number in range(1, 10):
    assert bindings[f"alt-{number}"] == f"workspace {number}"
    assert bindings[f"alt-shift-{number}"] == f"move-node-to-workspace {number}"
assert bindings["alt-backtick"] == "reload-config"
assert bindings["alt-q"] == "close"

print("App config test passed (JSON/TOML, theme, AeroSpace hooks and bindings; no live commands)")

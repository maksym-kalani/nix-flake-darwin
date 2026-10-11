# SketchyBar in Nix

This config comes from `~/.config/sketchybar`. It takes priority over the older
Bash config in `~/Downloads/dotfiles3/sketchybar`.

The theme, layout, widgets, app mappings, and disabled Messages widget are kept.
The source files now live in this flake. No files in the live config are changed
by a build.

## Dependencies

`../default.nix` provides:

- SketchyBar with a Nix wrapper.
- Lua 5.4 and SbarLua built for the same Lua version.
- The `cpu_load`, `network_load`, and `menus` helpers, built from C source.
- AeroSpace, SwitchAudioSource, nowplaying-cli, and jq in the wrapper's PATH.
- The existing `sketchybar-app-font-bg.ttf`, copied into `fonts/` without changes.
- The standard SketchyBar app font from Nixpkgs.

Home Manager installs the fonts under `~/Library/Fonts/HomeManager` during a
future activation. The background font and `helpers/icon_map.lua` are kept as a
matching pair. Its upstream project is
[sketchybar-app-font-bg](https://github.com/SoichiroYamane/sketchybar-app-font-bg).

SF Pro, SF Mono, and SF Symbols stay declared in `../../../darwin/homebrew.nix`.

## Builds

Run the isolated checks:

```sh
nix flake check
```

Build the Home Manager configuration without activating it:

```sh
nix build .#homeConfigurations.maksym.activationPackage --no-link
```

Nix compiles the helpers during the build. The config does not run `make`, clone
SbarLua, or download fonts at startup. Helper paths retain their original layout.
The generated `sketchybarrc` uses the Nix Lua interpreter, not Homebrew Lua.

The config test uses a fake SketchyBar API. It does not start a bar, run helper
processes, send events, or change system permissions.

## Activation is separate

No activation is part of these build commands. The current `~/.config/sketchybar`
directory remains in use until a later Home Manager activation. Home Manager
will report conflicts with its files; do not force an overwrite. Back up the live
config before switching.

The AeroSpace config in `../../aerospace/aerospace.toml` starts SketchyBar and sends
workspace change events. The AeroSpace module manages that file without changing
its settings. This module does not enable a second SketchyBar launch agent. After
activation, AeroSpace must use the Nix `sketchybar` wrapper from the user profile.

The new `menus` helper can need Accessibility permission. Spotify controls can
need Automation permission. Permission prompts must be handled after activation.

## Sources

Based on the live config, which credits:

- [Praveen Gongada's dotfiles](https://github.com/PraveenGongada/dotfiles)
- [Adrian Karlen's dotfiles](https://github.com/adriankarlen/dots)

The older Downloads README describes a different Bash setup. Its `icon_map.sh`
installer is not used by this Lua config.

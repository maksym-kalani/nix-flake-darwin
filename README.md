# macOS Nix config

This flake manages packages, shell settings, and app configs for `maksymkalani`
on `Maksyms-MacBook-Pro` (`aarch64-darwin`).

## Layout

```text
flake.nix                 Flake inputs, outputs, and build checks
flake.lock                Pinned input versions
home/
  default.nix             Home Manager entry point
  packages.nix            General packages
  zsh.nix                 Zsh settings and integrations
  oh-my-posh/
    default.nix           Prompt integration
    probua.minimal.omp.json
  aerospace/
    default.nix           Home Manager file declaration
    aerospace.toml
  sketchybar/
    default.nix           Packages, helper builds, and config generation
    config/               Lua config, C helper sources, and fonts
darwin/
  default.nix             nix-darwin entry point
  homebrew.nix            Packages that remain in Homebrew
helpers/
  nix-helpers.nix         ns and rebuild command definitions
tests/
  app-configs.py          Isolated JSON/TOML and integration checks
  sketchybar.lua          Isolated config test with a fake SketchyBar API
```

## App config files

- Oh My Posh uses `home/oh-my-posh/probua.minimal.omp.json` directly from the Nix
  store. This is an unchanged copy of `~/probua.minimal.omp.json`. It replaces the
  equivalent settings that were inline in the Zsh module.
- AeroSpace uses `home/aerospace/aerospace.toml`, an unchanged copy of the current
  `~/.aerospace.toml`. Home Manager declares that home file. The existing login
  startup, borders command, key bindings, monitor rules, and SketchyBar hooks stay
  in the TOML file. No Home Manager launch agent or reload hook is added.
- SketchyBar uses the current Lua config under `home/sketchybar/config/`. See its
  [README](home/sketchybar/config/README.md) for helper, font, and permission details.

AeroSpace stays in `home/packages.nix`. Its TOML file is managed directly because
this pinned Home Manager's AeroSpace settings module changes login startup.

Edit the copies in this flake for future changes. Builds no longer read the
original theme or AeroSpace file from the home directory.

## Build and check without activation

Run from the flake root:

```sh
nix flake check --all-systems --no-write-lock-file
nix build .#homeConfigurations.maksymkalani.activationPackage --no-link --no-write-lock-file
nix build '.#darwinConfigurations.Maksyms-MacBook-Pro.system' --no-link --no-write-lock-file
```

The tests parse the declarative JSON/TOML sources and load SketchyBar with a fake
API. They do not start apps, run live commands, or change permissions.

## Update and activate

These commands only build. They do not activate configs, remove Homebrew
packages, or reload running services. Homebrew activation cleanup stays disabled.

To update all flake inputs and apply the complete configuration, run:

```sh
nix flake update && rebuild
```

`rebuild` activates nix-darwin. Home Manager is embedded in the nix-darwin
configuration, so the same system generation activates the user configuration.
Home Manager also updates `rebuild`, `ns`, and `claude-code`. The standalone
`homeConfigurations` output remains available for build checks, but `rebuild`
does not activate it separately. Homebrew auto-update, package upgrades, and
cleanup stay disabled.

The first Home Manager activation can conflict with existing `.aerospace.toml`
and SketchyBar files. Back up those files before switching. Do not force an
overwrite. AeroSpace must also resolve the Nix SketchyBar wrapper rather than the
older Homebrew binary after activation.

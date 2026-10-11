{ config, lib, ... }:
let
  user = config.system.primaryUser;
in
{
  # AeroSpace and SketchyBar come from Nix (see home/). Remove the Homebrew
  # copies so their binaries and AeroSpace.app cannot shadow the Nix ones.
  # Homebrew cleanup stays disabled, so only these two are removed.
  system.activationScripts.postActivation.text = lib.mkBefore ''
    brew() { sudo --user=${user} --set-home -- /opt/homebrew/bin/brew "$@"; }
    if [ -x /opt/homebrew/bin/brew ]; then
      if brew list --cask aerospace >/dev/null 2>&1; then
        echo "removing Homebrew AeroSpace (managed by Nix)..." >&2
        brew uninstall --cask aerospace
      fi
      if brew list --formula sketchybar >/dev/null 2>&1; then
        echo "removing Homebrew SketchyBar (managed by Nix)..." >&2
        brew services stop sketchybar >/dev/null 2>&1 || true
        brew uninstall --formula sketchybar
      fi
    fi
  '';

  homebrew = {
    enable = true;

    global.brewfile = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      upgrade = true;
    };

    taps = [
      {
        name = "avivsinai/tap";
        trusted = true;
      }
      {
        name = "shriram-ethiraj/grayslate";
        trusted = true;
      }
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
      {
        name = "felixkratz/formulae";
        trusted = true;
      }
    ];

    brews = [
      "felixkratz/formulae/borders"
      "findutils"
      "gawk"
      "gh"
      "gnu-sed"
      "gnu-tar"
      "grep"
      "tccutil"
    ];

    casks = [
      "discord"
      "element"
      "font-sf-mono"
      "font-sf-pro"
      "jellyfin-media-player"
      "obs"
      "obsidian"
      "raycast"
      "shriram-ethiraj/grayslate/grayslate"
      "sf-symbols"
      "spotify"
      "telegram"
      "zed"
      "zen"
    ];
  };
}

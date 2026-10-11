{ nix-flake, pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./zsh.nix
    ./oh-my-posh
    ./aerospace
    ./sketchybar
    "${nix-flake}/home/features/pi-coding-agent"
  ];

  features.piCodingAgent.enable = true;
  # pi installs its `npm:` packages at runtime.
  programs.pi-coding-agent.extraPackages = [ pkgs.nodejs ];

  home = {
    username = "maksym";
    homeDirectory = "/Users/maksym";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}

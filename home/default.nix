{
  imports = [
    ./packages.nix
    ./zsh.nix
    ./oh-my-posh
    ./aerospace
    ./sketchybar
  ];

  home = {
    username = "maksymkalani";
    homeDirectory = "/Users/maksymkalani";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}

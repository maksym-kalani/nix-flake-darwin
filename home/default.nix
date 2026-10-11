{
  imports = [
    ./packages.nix
    ./zsh.nix
    ./oh-my-posh
    ./aerospace
    ./sketchybar
  ];

  home = {
    username = "maksym";
    homeDirectory = "/Users/maksym";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}

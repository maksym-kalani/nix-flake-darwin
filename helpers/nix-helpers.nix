{
  pkgs,
  nixpkgs,
  darwinRebuild,
  system,
}:
let
  shellPackages = pkgs.writeText "shell-packages.nix" ''
    import ${nixpkgs} {
      system = "${system}";
      config.allowUnfree = true;
    }
  '';
in
pkgs.buildEnv {
  name = "nix-helpers";
  paths = [
    (pkgs.writeShellScriptBin "ns" ''
      exec nix shell --file ${shellPackages} "$@"
    '')
    (pkgs.writeShellScriptBin "rebuild" ''
      exec sudo ${darwinRebuild}/bin/darwin-rebuild switch \
        --flake "$HOME/.config/nixpkgs#Maksyms-MacBook-Pro"
    '')
  ];
}

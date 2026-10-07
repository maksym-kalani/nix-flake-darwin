{
  description = "Declarative user packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "maksymkalani";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      nixHelpers = import ./helpers/nix-helpers.nix {
        inherit
          pkgs
          nixpkgs
          system
          ;
        darwinRebuild = nix-darwin.packages.${system}.default;
      };
    in
    {
      checks.${system} = {
        sketchybar = self.homeConfigurations.${username}.config.programs.sketchybar.config.source;
        app-configs = pkgs.runCommand "app-configs-check" { nativeBuildInputs = [ pkgs.python3 ]; } ''
          python ${./tests/app-configs.py} \
            ${self.homeConfigurations.${username}.config.programs.oh-my-posh.configFile} \
            ${self.homeConfigurations.${username}.config.home.file.".aerospace.toml".source}
          touch "$out"
        '';
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit nixHelpers; };
        modules = [ ./home ];
      };

      darwinConfigurations."Maksyms-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit username;
          hostPlatform = system;
        };
        modules = [
          ./darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              extraSpecialArgs = { inherit nixHelpers; };
              users.${username} = ./home;
            };
          }
        ];
      };
    };
}

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

    # Source-only: modules are imported from here, not copied into this repo.
    nix-flake = {
      url = "github:maksym-kalani/nix-flake/develop";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-flake,
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "maksym";
      hostname = "FunBook";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      nixHelpers = import ./helpers/nix-helpers.nix {
        inherit
          pkgs
          nixpkgs
          system
          hostname
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
        extraSpecialArgs = { inherit nixHelpers nix-flake; };
        modules = [ ./home ];
      };

      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit username hostname;
          hostPlatform = system;
        };
        modules = [
          ./darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = false;
              # Rename files that are in the way (e.g. ~/.zshrc -> ~/.zshrc.hm-backup).
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit nixHelpers nix-flake; };
              users.${username} = ./home;
            };
          }
        ];
      };
    };
}

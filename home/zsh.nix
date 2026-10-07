{ pkgs, ... }:
{
  home.packages = [ pkgs.starship ];

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "aws"
          "sudo"
        ];
        theme = "robbyrussell";
      };

      shellAliases = {
        sso-dev = "aws-vault exec sso-dev-admin";
        sso-qa = "aws-vault exec sso-qa-admin";
        sso-tests = "aws-vault exec sso-qa-developer";
        sso-srv = "aws-vault exec sso-srv-read-only";
        sso-prod = "aws-vault exec sso-prod-developer";
        dev-cp-token = "sso-dev -- AudienceProject.TokenHelper --env dev --apis org";
        qa-cp-token = "sso-qa -- AudienceProject.TokenHelper --env qa1 --apis org";
        tests-cp-token = "sso-tests -- AudienceProject.TokenHelper --env tests --apis org";
        prod-cp-token = "sso-prod -- AudienceProject.TokenHelper --env prod --apis org";
        ls = "eza -a --icons=always";
        ll = "eza -al --icons=always";
        lt = "eza -a --tree --level=1 --icons=always";
        c = "clear";
      };

      sessionVariables = {
        VISUAL = "/Applications/Zed.app/Contents/MacOS/cli --wait";
        EDITOR = "/Applications/Zed.app/Contents/MacOS/cli --wait";
        OPS_PREFIX = "mk";
        ENV = "dev";
        NIXPKGS_ALLOW_UNFREE = "1";
        AWS_REGION = "us-east-1";
        DOTNET_ENVIRONMENT = "Development";
        ASPNETCORE_ENVIRONMENT = "Development";
      };

      envExtra = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';

      profileExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"

        # Added by Toolbox App
        export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

        # Add .NET Core SDK tools
        export PATH="$PATH:$HOME/.dotnet/tools"

        # Hermes Agent — ensure ~/.local/bin is on PATH
        export PATH="$HOME/.local/bin:$PATH"

        # Load Nix for login shells.
        if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fi
      '';
    };
  };
}

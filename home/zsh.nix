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
        ls = "eza -a --icons=always";
        ll = "eza -al --icons=always";
        lt = "eza -a --tree --level=1 --icons=always";
        c = "clear";
      };

      sessionVariables = {
        VISUAL = "/Applications/Zed.app/Contents/MacOS/cli --wait";
        EDITOR = "/Applications/Zed.app/Contents/MacOS/cli --wait";
        NIXPKGS_ALLOW_UNFREE = "1";
      };

      envExtra = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';

      profileExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"

        # Hermes Agent — ensure ~/.local/bin is on PATH
        export PATH="$HOME/.local/bin:$PATH"

        # Load Nix for login shells.
        if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fi

        # Prefer Nix packages over Homebrew ones with the same name.
        export PATH="$HOME/.nix-profile/bin:$PATH"
      '';
    };
  };
}

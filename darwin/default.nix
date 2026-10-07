{ hostPlatform, username, ... }:
{
  imports = [ ./homebrew.nix ];

  nix.enable = false;
  nixpkgs = {
    hostPlatform = hostPlatform;
    config.allowUnfree = true;
  };

  users.users.${username}.home = "/Users/${username}";

  system = {
    primaryUser = username;
    stateVersion = 6;
  };
}

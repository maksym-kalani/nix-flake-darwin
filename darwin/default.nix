{
  hostPlatform,
  hostname,
  username,
  ...
}:
{
  imports = [
    ./defaults.nix
    ./homebrew.nix
  ];

  networking = {
    hostName = hostname;
    computerName = hostname;
    localHostName = hostname;
  };

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

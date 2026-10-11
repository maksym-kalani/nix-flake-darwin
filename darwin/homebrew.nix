{
  homebrew = {
    enable = true;

    global.brewfile = true;

    onActivation = {
      autoUpdate = true;
      # Uninstall formulae, casks and taps not declared here. App data in
      # ~/Library is kept (unlike "zap").
      cleanup = "uninstall";
      upgrade = true;
    };

    taps = [
      {
        name = "avivsinai/tap";
        trusted = true;
      }
      {
        name = "shriram-ethiraj/grayslate";
        trusted = true;
      }
    ];

    brews = [ "tccutil" ];

    casks = [
      # The Nix build patches the bundle and breaks its signature, so macOS
      # reports it as damaged.
      "discord"
      "font-sf-mono"
      "font-sf-pro"
      "obs"
      "shriram-ethiraj/grayslate/grayslate"
      "sf-symbols"
      "telegram"
      "zen"
    ];
  };
}

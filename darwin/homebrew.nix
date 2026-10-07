{
  homebrew = {
    enable = true;

    global.brewfile = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "none";
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
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
      {
        name = "felixkratz/formulae";
        trusted = true;
      }
    ];

    brews = [
      "node"
      "aws-cdk"
      "awscli"
      "cdk"
      {
        name = "dotnet@8";
        link = true;
      }
      "dotnet"
      # Keg-only. psql, pg_dump, and pg_restore. Nix libpq has no binaries.
      "libpq"
      "felixkratz/formulae/borders"
      "parquet-cli"
      "tccutil"
      "avivsinai/tap/bitbucket-cli"
    ];

    casks = [
      "nikitabobko/tap/aerospace"
      "docker-desktop"
      "font-sf-mono"
      "font-sf-pro"
      "shriram-ethiraj/grayslate/grayslate"
      "marta"
      "sf-symbols"
      "windows-app"
    ];
  };
}

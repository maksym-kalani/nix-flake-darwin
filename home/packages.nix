{ nixHelpers, pkgs, ... }:
let
  lua54 = pkgs.runCommand "lua-5.4-versioned" { } ''
    mkdir -p "$out/bin"
    ln -s ${pkgs.lua5_4}/bin/lua "$out/bin/lua5.4"
    ln -s ${pkgs.lua5_4}/bin/luac "$out/bin/luac5.4"
  '';
in
{
  home.packages = with pkgs; [
    aerospace
    element-desktop
    gh
    jankyborders
    jellyfin-desktop
    obsidian
    spotify
    zed-editor
    claude-code
    bat
    betterdisplay
    codex
    coreutils
    curl
    eza
    fastfetch
    fd
    findutils
    ffmpeg
    gawk
    git
    gnugrep
    gnused
    gnutar
    jq
    keycastr
    kitty
    libpq
    lua5_5
    lua54
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
    nerd-fonts.hack
    nowplaying-cli
    nixHelpers
    opencode
    openssh
    pi-coding-agent
    pnpm
    ripgrep
    stow
    switchaudio-osx
    tmux
    tree
    vicinae
    nil
  ];
}

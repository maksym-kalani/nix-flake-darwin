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
    acli
    aerospace
    claude-code
    aws-vault
    bat
    betterdisplay
    codex
    colordiff
    coreutils
    curl
    eza
    fastfetch
    fd
    ffmpeg
    flameshot
    git
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
    powershell
    rich-cli
    ripgrep
    stow
    switchaudio-osx
    tmux
    tree
    yarn
    yazi
  ];
}

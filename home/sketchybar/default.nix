{ pkgs, ... }:
let
  lua = pkgs.lua5_4;
  sbarLua =
    (pkgs.sbarlua.override {
      lua55Packages = pkgs.lua54Packages;
      gcc = pkgs.stdenv.cc;
    }).overrideAttrs
      (old: {
        # Upstream bundles Lua 5.5. Link to our Lua 5.4 library instead.
        buildInputs = (old.buildInputs or [ ]) ++ [ lua ];
        buildPhase = ''
          runHook preBuild
          mkdir -p bin
          $CC -std=c99 -O3 -shared -fPIC src/sketchybar.c src/cJSON.c src/parsing.c \
            -I${lua}/include -L${lua}/lib -llua -framework CoreFoundation \
            -o bin/sketchybar.so
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          install -Dm755 bin/sketchybar.so "$out/lib/lua/${lua.luaversion}/sketchybar.so"
          runHook postInstall
        '';
      });

  helpers = pkgs.stdenv.mkDerivation {
    pname = "sketchybar-helpers";
    version = "local";
    src = ./config/helpers;

    buildInputs = [ pkgs.apple-sdk_15 ];
    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      mkdir -p bin
      $CC -std=c99 -O3 event_providers/cpu_load/cpu_load.c -o bin/cpu_load
      $CC -std=c99 -O3 event_providers/network_load/network_load.c -o bin/network_load
      $CC -std=c99 -O3 -F"$SDKROOT/System/Library/PrivateFrameworks" \
        -framework Carbon -framework SkyLight menus/menus.c -o bin/menus

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      cp bin/cpu_load bin/network_load bin/menus "$out/bin/"
      runHook postInstall
    '';
  };

  appFont = pkgs.runCommand "sketchybar-app-font-bg" { } ''
    install -Dm644 ${./config/fonts/sketchybar-app-font-bg.ttf} \
      "$out/share/fonts/truetype/sketchybar-app-font-bg.ttf"
  '';

  configuration = pkgs.runCommand "sketchybar-config" { nativeBuildInputs = [ lua ]; } ''
    mkdir -p "$out"
    cp -R ${./config}/. "$out/"
    chmod -R u+w "$out"

    substituteInPlace "$out/sketchybarrc" \
      --replace-fail '#!/usr/bin/env lua' '#!${lua}/bin/lua'

    mkdir -p "$out/helpers/event_providers/cpu_load/bin" \
      "$out/helpers/event_providers/network_load/bin" "$out/helpers/menus/bin"
    ln -s ${helpers}/bin/cpu_load "$out/helpers/event_providers/cpu_load/bin/cpu_load"
    ln -s ${helpers}/bin/network_load "$out/helpers/event_providers/network_load/bin/network_load"
    ln -s ${helpers}/bin/menus "$out/helpers/menus/bin/menus"

    while IFS= read -r -d "" file; do
      luac -p "$file"
    done < <(find "$out" -type f -name '*.lua' -print0)
    luac -p "$out/sketchybarrc"

    LUA_CPATH='${lua.pkgs.getLuaCPath sbarLua};;' \
      lua -e 'assert(type(require("sketchybar")) == "table")'
    LUA_PATH="$out/?.lua;$out/?/init.lua;;" \
      lua ${../../tests/sketchybar.lua}
  '';
in
{
  home.packages = [
    appFont
    pkgs.sketchybar-app-font
  ];

  programs.sketchybar = {
    enable = true;
    configType = "lua";
    luaPackage = lua;
    sbarLuaPackage = sbarLua;
    config = {
      source = configuration;
      recursive = true;
    };
    extraPackages = with pkgs; [
      aerospace
      switchaudio-osx
      nowplaying-cli
      jq
    ];

    # AeroSpace already starts SketchyBar. Do not start a second instance.
    service.enable = false;
  };
}

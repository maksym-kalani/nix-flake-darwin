# macOS settings changed from their defaults on this machine.
{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      # SketchyBar replaces the menu bar.
      _HIHideMenuBar = true;
      # Use F1, F2, etc. as standard function keys.
      "com.apple.keyboard.fnState" = true;
      # Key repeat: 2 = fastest repeat, 30 = short delay before repeating.
      KeyRepeat = 2;
      InitialKeyRepeat = 30;
    };

    dock = {
      autohide = true;
      launchanim = false;
      orientation = "right";
      show-recents = false;
      persistent-apps = [
        "/Applications/Zen.app"
        "/System/Applications/System Settings.app"
      ];
    };

    finder = {
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
    };

    screencapture.target = "clipboard";

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      EnableTiledWindowMargins = false;
      HideDesktop = true;
      StandardHideDesktopIcons = true;
    };

    CustomUserPreferences = {
      # Purple accent color.
      NSGlobalDomain.AppleAccentColor = 5;
      # Menu bar: automatically hide "Always".
      "com.apple.controlcenter".AutoHideMenuBarOption = 0;
    };
  };
}

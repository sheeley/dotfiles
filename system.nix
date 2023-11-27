{
  pkgs,
  user,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
    };
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.defaults = {
    dock = {
      autohide = true;
      launchanim = false;
      show-recents = false;
      mineffect = "scale";
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = false;
      ShowSidebar = true;
      ShowStatusBar = true;
    };

    screencapture.location = "~/Screenshots";

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleMiniaturizeOnDoubleClick = false;
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        WebAutomaticSpellingCorrectionEnabled = false;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.flash" = 0;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.uiaudio.enabled" = 0;
      };

      "com.apple.controlcenter" = {
        "NSStatusItem Visible Bluetooth" = true;
        "NSStatusItem Visible Sound" = true;
        "NSStatusItem Visible FocusModes" = true;
        "NSStatusItem Visible WiFi" = true;
      };

      "com.apple.Safari" = {
        AutoFillPasswords = false;
        IncludeDevelopMenu = true;
        ShowFullURLInSmartSearchField = true;
        ShowOverlayStatusBar = true;
        TouchIDToAutoFill = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        "WebKitPreferences.developerExtrasEnabled" = true;
      };

      "com.apple.Siri" = {
        StatusMenuVisible = false;
      };

      "com.googlecode.iterm2" = {
        PrefsCustomFolder = "/Users/sheeley/dotfiles/preferences";
      };
    };
  };
}

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

      "com.apple.Safari" = {
        AutoFillPasswords = false;
        IncludeDevelopMenu = true;
      };

      "com.googlecode.iterm2" = {
        PrefsCustomFolder = "/Users/sheeley/dotfiles/preferences";
      };
    };
  };
}

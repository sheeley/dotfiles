{
  config,
  pkgs,
  lib,
  user,
  inputs,
  private,
  ...
}: let
in {
  imports = [
    ./dock.nix
  ];

  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      private = private;
    };
  };
  # verbose = true;

  home-manager.users.${user} = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs.bash.enable = true;
    programs.home-manager.enable = true;

    imports =
      [
        inputs.nixvim.homeManagerModules.nixvim
        ./programs/fish.nix
        ./programs/general.nix
        ./programs/git.nix
        ./programs/gitui.nix
        ./programs/helix.nix
        ./programs/neovim.nix
        ./programs/nushell.nix
        ./programs/ssh.nix
        ./programs/starship.nix
        ./programs/vscode.nix
        ./programs/zsh.nix
      ]
      ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
        # personal only
      ]);

    home = {
      stateVersion = "22.05";

      # TODO: pkgs.callPackage ./environment_variables.nix {private = private;};
      sessionVariables = {
        # BORG_PASSPHRASE = "${private.borgSecret}";
        BORG_REPO = "/Volumes/money/borgbackup";
        DOTFILES_DIR = toString ~/dotfiles;
        EDITOR = "nvim";
        GITHUB_TOKEN = "${private.githubSecret}";
        GOPATH = toString ~/go;
        GOPROXY = "direct";
        GOSUMDB = "off";
        ICLOUD_DIR = toString (~/Library + "/Mobile Documents/com~apple~CloudDocs");
        LESS = "-R";
        N_PREFIX = "$HOME/.n";
        NOTES_DIR = toString ~/projects/sheeley/notes;
        PRIVATE_CMD_DIR = toString ~/projects/sheeley/infrastructure/cmd;
        PRIVATE_DATA_DIR = toString ~/projects/sheeley/infrastructure/data;
        PRIVATE_TOOLS_DIR = toString ~/projects/sheeley/infrastructure;
        TOOLS_DIR = toString ~/dotfiles/bin;
        WORK_NOTES_DIR = toString (~/Library + "/Mobile Documents/iCloud~md~obsidian/Documents/Apple Notes");
        WORKMACHINE = "false";
      };

      # this sometimes doesn't work with fish
      # https://github.com/LnL7/nix-darwin/issues/122
      sessionPath = pkgs.callPackage ./environment_path.nix {};

      packages = pkgs.callPackage ./packages.nix {
        lib = lib;
        private = private;
      };

      file = {
        ".mongorc.js".text = builtins.readFile ./files/.mongorc.js;
        ".swiftformat".text = builtins.readFile ./files/.swiftformat;
        ".swiftlint.yml".text = builtins.readFile ./files/.swiftlint.yml;
        ".vim/ftdetect/toml.vim".text = "autocmd BufNewFile,BufRead *.toml set filetype=toml";

        # link instead of make a real file because this needs to be modified to login/etc
        ".npmrc".source = config.lib.file.mkOutOfStoreSymlink ./files/.npmrc;

        # ".config/rclone/rclone.conf".source = pkgs.substituteAll {
        #   name = "rclone.conf";
        #   src = ./files/rclone.conf;
        #   user = "${private.borgUser}";
        # };
      };

      shellAliases = {
        cat = "bat";
        cddot = "cd ~/dotfiles";
        cdgo = "cd $GOPATH/src";
        cdicloud = "cd $ICLOUD_DIR";
        cdinfra = "cd $PRIVATE_TOOLS_DIR";
        cdnotes = "cd $NOTES_DIR";
        cdproj = "cd $HOME/projects/sheeley";
        cdscratch = "cd ~/scratch";
        cdtools = "cd $TOOLS_DIR";
        cdwork = "cd ~/work";
        cdworknotes = "cd $WORK_NOTES_DIR";
        clone = "git clone";
        la = "ls -la";
      };
    };

    targets.darwin.defaults = {
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

      "com.apple.Finder" = {
        ShowPathBar = true;
        ShowSidebar = true;
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
        PrefsCustomFolder = toString ~/dotfiles/preferences;
      };

      "com.apple.dock" = {
        autohide = true;
        launchanim = false;
        show-recents = false;
        mineffect = "scale";
      };

      "com.apple.finder" = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        ShowStatusBar = true;
      };

      "com.apple.screencapture" = {
        location = ~/Screenshots;
      };

      "com.agilebits.onepassword7.1PasswordSafariAppExtension" = {
        AutoshowDisabled = 0;
        InlineDisabled = 1;
      };

      "com.abhishek.Clocker" = {
        MigrateIndividualTimezoneFormat = 1;

        ShowUpcomingEventView = false;

        "com.abhishek.menubarCompactMode" = 0;
        "com.abhishek.shouldDefaultToCompactMode" = 1;
        "com.abhishek.showOnboardingFlow" = 1;
        "com.abhishek.switchToCompactMode" = 1;

        defaultTheme = 2;

        is24HourFormatSelected = 1;
        # menubarFavourites = "<array>\\n  <data>\\n  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy\\n  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV\\n  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp\\n  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk\\n  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q\\n  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u\\n  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA\\n  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKUlZXcDcyQ2VqNEFScHh2\\n  TUxmVDhqdjBZU2FuIE1hdGVvUlNNXxATQW1lcmljYS9Mb3NfQW5nZWxlc9It\\n  Ei4vV05TLnRpbWUjQcGsMUjzU0iAB9IxMjM0WiRjbGFzc25hbWVYJGNsYXNz\\n  ZXNWTlNEYXRlojM1WE5TT2JqZWN0I0BCyBAcrbWwI8BelNVofMEcUNIxMjo7\\n  XxAUQ2xvY2tlci5UaW1lem9uZURhdGGiPDVfEBRDbG9ja2VyLlRpbWV6b25l\\n  RGF0YV8QD05TS2V5ZWRBcmNoaXZlctE/QFRyb290gAEACAARABoAIwAtADIA\\n  NwBEAEoAbQCAAI8AmwCgAKsAtQC+AMwA2ADfAPIA/QEGAREBKQE1ATYBOAE6\\n  ATwBPgFAAUIBRAFGAUgBSgFMAU4BUAFSAXABegF9AZMBmAGgAakBqwGwAbsB\\n  xAHLAc4B1wHgAekB6gHvAgYCCQIgAjICNQI6AAAAAAAAAgEAAAAAAAAAQQAA\\n  AAAAAAAAAAAAAAAAAjw=\\n  </data>\\n  <data>\\n  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy\\n  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV\\n  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp\\n  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk\\n  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q\\n  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u\\n  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA\\n  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKMDYtTkowNk5hNGNSV0lB\\n  Ym9IdzdPY2dXQm91bGRlclJDT15BbWVyaWNhL0RlbnZlctItEi4vV05TLnRp\\n  bWUjQcGsMTybwAmAB9IxMjM0WiRjbGFzc25hbWVYJGNsYXNzZXNWTlNEYXRl\\n  ojM1WE5TT2JqZWN0I0BEAesMUvSaI8BaUVCefgTpUNIxMjo7XxAUQ2xvY2tl\\n  ci5UaW1lem9uZURhdGGiPDVfEBRDbG9ja2VyLlRpbWV6b25lRGF0YV8QD05T\\n  S2V5ZWRBcmNoaXZlctE/QFRyb290gAEACAARABoAIwAtADIANwBEAEoAbQCA\\n  AI8AmwCgAKsAtQC+AMwA2ADfAPIA/QEGAREBKQE1ATYBOAE6ATwBPgFAAUIB\\n  RAFGAUgBSgFMAU4BUAFSAXABeAF7AYoBjwGXAaABogGnAbIBuwHCAcUBzgHX\\n  AeAB4QHmAf0CAAIXAikCLAIxAAAAAAAAAgEAAAAAAAAAQQAAAAAAAAAAAAAA\\n  AAAAAjM=\\n  </data>\\n  <data>\\n  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy\\n  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV\\n  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp\\n  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk\\n  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q\\n  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u\\n  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA\\n  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKNjZfTzhSYTM1WWdSNHNm\\n  OGxqaDl6Y1FcSmFja3NvbnZpbGxlU0pBWF8QEEFtZXJpY2EvTmV3X1lvcmvS\\n  LRIuL1dOUy50aW1lI0HBrDE5TRQBgAfSMTIzNFokY2xhc3NuYW1lWCRjbGFz\\n  c2VzVk5TRGF0ZaIzNVhOU09iamVjdCNAPlUJ/11C0SPAVGn2L5ylvVDSMTI6\\n  O18QFENsb2NrZXIuVGltZXpvbmVEYXRhojw1XxAUQ2xvY2tlci5UaW1lem9u\\n  ZURhdGFfEA9OU0tleWVkQXJjaGl2ZXLRP0BUcm9vdIABAAgAEQAaACMALQAy\\n  ADcARABKAG0AgACPAJsAoACrALUAvgDMANgA3wDyAP0BBgERASkBNQE2ATgB\\n  OgE8AT4BQAFCAUQBRgFIAUoBTAFOAVABUgFwAX0BgQGUAZkBoQGqAawBsQG8\\n  AcUBzAHPAdgB4QHqAesB8AIHAgoCIQIzAjYCOwAAAAAAAAIBAAAAAAAAAEEA\\n  AAAAAAAAAAAAAAAAAAI9\\n  </data>\\n  <data>\\n  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy\\n  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV\\n  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp\\n  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk\\n  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q\\n  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u\\n  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA\\n  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKMl9VbVVreE5la2dScW12\\n  LUJEZ1V2dGtaTWFuY2hlc3RlclNNQU5dRXVyb3BlL0xvbmRvbtItEi4vV05T\\n  LnRpbWUjQcGsMTVkD16AB9IxMjM0WiRjbGFzc25hbWVYJGNsYXNzZXNWTlNE\\n  YXRlojM1WE5TT2JqZWN0I0BKvYmFT1+6I8AB8OhCdBjXUNIxMjo7XxAUQ2xv\\n  Y2tlci5UaW1lem9uZURhdGGiPDVfEBRDbG9ja2VyLlRpbWV6b25lRGF0YV8Q\\n  D05TS2V5ZWRBcmNoaXZlctE/QFRyb290gAEACAARABoAIwAtADIANwBEAEoA\\n  bQCAAI8AmwCgAKsAtQC+AMwA2ADfAPIA/QEGAREBKQE1ATYBOAE6ATwBPgFA\\n  AUIBRAFGAUgBSgFMAU4BUAFSAXABewF/AY0BkgGaAaMBpQGqAbUBvgHFAcgB\\n  0QHaAeMB5AHpAgACAwIaAiwCLwI0AAAAAAAAAgEAAAAAAAAAQQAAAAAAAAAA\\n  AAAAAAAAAjY=\\n  </data>\\n  <data>\\n  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy\\n  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV\\n  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp\\n  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk\\n  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q\\n  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u\\n  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA\\n  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKeDlMcjZ0cVp5enNSd3Z1\\n  NmtvTzNrNjRZSHlkZXJhYmFkU0hZRF1Bc2lhL0NhbGN1dHRh0i0SLi9XTlMu\\n  dGltZSNBwc2IwR0KPYAH0jEyMzRaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0Rh\\n  dGWiMzVYTlNPYmplY3QjQDFikj5bhWIjQFOfJZ4fOlhQ0jEyOjtfEBRDbG9j\\n  a2VyLlRpbWV6b25lRGF0YaI8NV8QFENsb2NrZXIuVGltZXpvbmVEYXRhXxAP\\n  TlNLZXllZEFyY2hpdmVy0T9AVHJvb3SAAQAIABEAGgAjAC0AMgA3AEQASgBt\\n  AIAAjwCbAKAAqwC1AL4AzADYAN8A8gD9AQYBEQEpATUBNgE4AToBPAE+AUAB\\n  QgFEAUYBSAFKAUwBTgFQAVIBcAF6AX4BjAGRAZkBogGkAakBtAG9AcQBxwHQ\\n  AdkB4gHjAegB/wICAhkCKwIuAjMAAAAAAAACAQAAAAAAAABBAAAAAAAAAAAA\\n  AAAAAAACNQ==\\n  </data>\\n</array>";
        showDay = 1;
      };

      "com.crowdcafe.windowmagnet" = {
        bezelDisplayTime = 1;
        centerWindowComboKey = {
        };
        expandWindowCenterThirdComboKey = {
        };
        expandWindowEastComboKey = {
          keyCode = 124;
          modifierFlags = 1835008;
        };
        expandWindowLeftThirdComboKey = {
        };
        expandWindowLeftTwoThirdsComboKey = {
        };
        expandWindowNorthComboKey = {
          keyCode = 126;
          modifierFlags = 1835008;
        };
        expandWindowNorthEastComboKey = {
          keyCode = 19;
          modifierFlags = 1835008;
        };
        expandWindowNorthWestComboKey = {
          keyCode = 18;
          modifierFlags = 1835008;
        };
        expandWindowRightThirdComboKey = {
        };
        expandWindowRightTwoThirdsComboKey = {
        };
        expandWindowSouthComboKey = {
          keyCode = 125;
          modifierFlags = 1835008;
        };
        expandWindowSouthEastComboKey = {
          keyCode = 21;
          modifierFlags = 1835008;
        };
        expandWindowSouthWestComboKey = {
          keyCode = 20;
          modifierFlags = 1835008;
        };
        expandWindowWestComboKey = {
          keyCode = 123;
          modifierFlags = 1835008;
        };
        lastRatedVersion = "2.13.0";
        launchAtLogin = 1;
        maximizeWindowComboKey = {
          keyCode = 3;
          modifierFlags = 1835008;
        };
        moveWindowToNextDisplay = {
          keyCode = 124;
          modifierFlags = 1310720;
        };
        moveWindowToPreviousDisplay = {
          keyCode = 123;
          modifierFlags = 1310720;
        };
        restoreWindowComboKey = {
        };
      };
    };
  };
}

{ pkgs, user, ... }:
{
nix = {
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

    CustomSystemPreferences = {
      NSGlobalDomain = {
        AppleMiniaturizeOnDoubleClick = false;
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        WebAutomaticSpellingCorrectionEnabled = false;
        "com.apple.sound.beep.flash" = 0;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.uiaudio.enabled" = 0;
      };

      "com.apple.Music" = {
        "library-url" = "file:///Users/${user}/Media/Music/Music%20Library.musiclibrary/";
        "media-folder-url" = "file:///Users/${user}/Media/Music/";
      };

      # TODO: try this
      # "com.apple.photolibraryd" = {
      #   SystemLibraryPath = "/Users/${user}/Media/Photos Library.photoslibrary";
      # };

      "com.apple.Safari" = {
        AutoFillPasswords = false;
        IncludeDevelopMenu = true;
      };

      "com.abhishek.Clocker" =
        {
          "com.abhishek.menubarCompactMode" = 0;
          "com.abhishek.shouldDefaultToCompactMode" = true;
          "com.abhishek.switchToCompactMode" = true;
          menubarFavourites = "<array>
  <data>
  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy
  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV
  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp
  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk
  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q
  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u
  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA
  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKUlZXcDcyQ2VqNEFScHh2
  TUxmVDhqdjBZU2FuIE1hdGVvUlNNXxATQW1lcmljYS9Mb3NfQW5nZWxlc9It
  Ei4vV05TLnRpbWUjQcGsMUjzU0iAB9IxMjM0WiRjbGFzc25hbWVYJGNsYXNz
  ZXNWTlNEYXRlojM1WE5TT2JqZWN0I0BCyBAcrbWwI8BelNVofMEcUNIxMjo7
  XxAUQ2xvY2tlci5UaW1lem9uZURhdGGiPDVfEBRDbG9ja2VyLlRpbWV6b25l
  RGF0YV8QD05TS2V5ZWRBcmNoaXZlctE/QFRyb290gAEACAARABoAIwAtADIA
  NwBEAEoAbQCAAI8AmwCgAKsAtQC+AMwA2ADfAPIA/QEGAREBKQE1ATYBOAE6
  ATwBPgFAAUIBRAFGAUgBSgFMAU4BUAFSAXABegF9AZMBmAGgAakBqwGwAbsB
  xAHLAc4B1wHgAekB6gHvAgYCCQIgAjICNQI6AAAAAAAAAgEAAAAAAAAAQQAA
  AAAAAAAAAAAAAAAAAjw=
  </data>
  <data>
  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy
  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV
  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp
  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk
  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q
  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u
  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA
  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKMDYtTkowNk5hNGNSV0lB
  Ym9IdzdPY2dXQm91bGRlclJDT15BbWVyaWNhL0RlbnZlctItEi4vV05TLnRp
  bWUjQcGsMTybwAmAB9IxMjM0WiRjbGFzc25hbWVYJGNsYXNzZXNWTlNEYXRl
  ojM1WE5TT2JqZWN0I0BEAesMUvSaI8BaUVCefgTpUNIxMjo7XxAUQ2xvY2tl
  ci5UaW1lem9uZURhdGGiPDVfEBRDbG9ja2VyLlRpbWV6b25lRGF0YV8QD05T
  S2V5ZWRBcmNoaXZlctE/QFRyb290gAEACAARABoAIwAtADIANwBEAEoAbQCA
  AI8AmwCgAKsAtQC+AMwA2ADfAPIA/QEGAREBKQE1ATYBOAE6ATwBPgFAAUIB
  RAFGAUgBSgFMAU4BUAFSAXABeAF7AYoBjwGXAaABogGnAbIBuwHCAcUBzgHX
  AeAB4QHmAf0CAAIXAikCLAIxAAAAAAAAAgEAAAAAAAAAQQAAAAAAAAAAAAAA
  AAAAAjM=
  </data>
  <data>
  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy
  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV
  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp
  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk
  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q
  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u
  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA
  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKNjZfTzhSYTM1WWdSNHNm
  OGxqaDl6Y1FcSmFja3NvbnZpbGxlU0pBWF8QEEFtZXJpY2EvTmV3X1lvcmvS
  LRIuL1dOUy50aW1lI0HBrDE5TRQBgAfSMTIzNFokY2xhc3NuYW1lWCRjbGFz
  c2VzVk5TRGF0ZaIzNVhOU09iamVjdCNAPlUJ/11C0SPAVGn2L5ylvVDSMTI6
  O18QFENsb2NrZXIuVGltZXpvbmVEYXRhojw1XxAUQ2xvY2tlci5UaW1lem9u
  ZURhdGFfEA9OU0tleWVkQXJjaGl2ZXLRP0BUcm9vdIABAAgAEQAaACMALQAy
  ADcARABKAG0AgACPAJsAoACrALUAvgDMANgA3wDyAP0BBgERASkBNQE2ATgB
  OgE8AT4BQAFCAUQBRgFIAUoBTAFOAVABUgFwAX0BgQGUAZkBoQGqAawBsQG8
  AcUBzAHPAdgB4QHqAesB8AIHAgoCIQIzAjYCOwAAAAAAAAIBAAAAAAAAAEEA
  AAAAAAAAAAAAAAAAAAI9
  </data>
  <data>
  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy
  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV
  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp
  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk
  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q
  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u
  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA
  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKMl9VbVVreE5la2dScW12
  LUJEZ1V2dGtaTWFuY2hlc3RlclNNQU5dRXVyb3BlL0xvbmRvbtItEi4vV05T
  LnRpbWUjQcGsMTVkD16AB9IxMjM0WiRjbGFzc25hbWVYJGNsYXNzZXNWTlNE
  YXRlojM1WE5TT2JqZWN0I0BKvYmFT1+6I8AB8OhCdBjXUNIxMjo7XxAUQ2xv
  Y2tlci5UaW1lem9uZURhdGGiPDVfEBRDbG9ja2VyLlRpbWV6b25lRGF0YV8Q
  D05TS2V5ZWRBcmNoaXZlctE/QFRyb290gAEACAARABoAIwAtADIANwBEAEoA
  bQCAAI8AmwCgAKsAtQC+AMwA2ADfAPIA/QEGAREBKQE1ATYBOAE6ATwBPgFA
  AUIBRAFGAUgBSgFMAU4BUAFSAXABewF/AY0BkgGaAaMBpQGqAbUBvgHFAcgB
  0QHaAeMB5AHpAgACAwIaAiwCLwI0AAAAAAAAAgEAAAAAAAAAQQAAAAAAAAAA
  AAAAAAAAAjY=
  </data>
  <data>
  YnBsaXN0MDDUAQIDBAUGPT5YJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVy
  VCR0b3ASAAGGoKwHCCgpKissMDY3ODlVJG51bGzfEBAJCgsMDQ4PEBESExQV
  FhcYGRobHB0eHyAhIiMkJSYaHV8QEGlzU3lzdGVtVGltZXpvbmVeb3ZlcnJp
  ZGVGb3JtYXRbY3VzdG9tTGFiZWxUbm90ZVpzdW5zZXRUaW1lWWxvbmdpdHVk
  ZVhsYXRpdHVkZV1zZWxlY3Rpb25UeXBlW2lzRmF2b3VyaXRlViRjbGFzc18Q
  EGZvcm1hdHRlZEFkZHJlc3NabmV4dFVwZGF0ZVhwbGFjZV9pZFp0aW1lem9u
  ZUlEXxAVc2Vjb25kc092ZXJyaWRlRm9ybWF0W3N1bnJpc2VUaW1lCBACgASA
  CoAAgAmACBAAEAGAC4ADgAaAAoAFgABfEBtDaElKeDlMcjZ0cVp5enNSd3Z1
  NmtvTzNrNjRZSHlkZXJhYmFkU0hZRF1Bc2lhL0NhbGN1dHRh0i0SLi9XTlMu
  dGltZSNBwc2IwR0KPYAH0jEyMzRaJGNsYXNzbmFtZVgkY2xhc3Nlc1ZOU0Rh
  dGWiMzVYTlNPYmplY3QjQDFikj5bhWIjQFOfJZ4fOlhQ0jEyOjtfEBRDbG9j
  a2VyLlRpbWV6b25lRGF0YaI8NV8QFENsb2NrZXIuVGltZXpvbmVEYXRhXxAP
  TlNLZXllZEFyY2hpdmVy0T9AVHJvb3SAAQAIABEAGgAjAC0AMgA3AEQASgBt
  AIAAjwCbAKAAqwC1AL4AzADYAN8A8gD9AQYBEQEpATUBNgE4AToBPAE+AUAB
  QgFEAUYBSAFKAUwBTgFQAVIBcAF6AX4BjAGRAZkBogGkAakBtAG9AcQBxwHQ
  AdkB4gHjAegB/wICAhkCKwIuAjMAAAAAAAACAQAAAAAAAABBAAAAAAAAAAAA
  AAAAAAACNQ==
  </data>
</array>";

        };

      "com.agilebits.onepassword7" = {
        OPPrefShowSafariInlineMenu = false;
        OPPrefShowSafariInlineMenuAutomatically = false;
        "ShortcutRecorder BrowserActivation" = "
<dict>
  <key>keyCode</key>
  <integer>-1</integer>
  <key>modifierFlags</key>
  <integer>0</integer>
  <key>modifiers</key>
  <integer>0</integer>
</dict>
";
        "ShortcutRecorder GlobalActivation" = "
<dict>
  <key>keyCode</key>
  <integer>-1</integer>
  <key>modifierFlags</key>
  <integer>0</integer>
  <key>modifiers</key>
  <integer>0</integer>
</dict>
";
        "ShortcutRecorder GlobalLock" = "
<dict>
  <key>keyCode</key>
  <integer>-1</integer>
  <key>modifierFlags</key>
  <integer>0</integer>
  <key>modifiers</key>
  <integer>0</integer>
</dict>
";
      };

      "com.googlecode.iterm2" = {
        AllowClipboardAccess = true;
        PromptOnQuit = false;
        VisualIndicatorForEsc = false;
      };

      # "com.crowdcafe.windowmagnet" = {
      #   centerWindowComboKey = { };
      #   expandWindowCenterThirdComboKey = { };
      #   expandWindowEastComboKey = {
      #     keyCode = 124;
      #     modifierFlags = 1835008;
      #   };
      #   expandWindowLeftThirdComboKey = { };
      #   expandWindowLeftTwoThirdsComboKey = { };
      #   expandWindowNorthComboKey = {
      #     keyCode = 126;
      #     modifierFlags = 1835008;
      #   };
      #   expandWindowNorthEastComboKey = {
      #     keyCode = 19;
      #     modifierFlags = 1835008;
      #   };
      #   expandWindowNorthWestComboKey = {
      #     keyCode = 18;
      #     modifierFlags = 1835008;
      #   };
      #   expandWindowRightThirdComboKey = { };
      #   expandWindowRightTwoThirdsComboKey = { };
      #   expandWindowSouthComboKey = {
      #     keyCode = 125;
      #     modifierFlags = 1835008;
      #   };
      #   expandWindowSouthEastComboKey = {
      #     keyCode = 21;
      #     modifierFlags = 1835008;
      #   };
      #   expandWindowSouthWestComboKey = {
      #     keyCode = 20;
      #     modifierFlags = 1835008;
      #   };
      #   expandWindowWestComboKey = {
      #     keyCode = 123;
      #     modifierFlags = 1835008;
      #   };
      #   maximizeWindowComboKey = {
      #     keyCode = 3;
      #     modifierFlags = 1835008;
      #   };
      #   moveWindowToNextDisplay = {
      #     keyCode = 123;
      #     modifierFlags = 1310720;
      #   };
      #   moveWindowToPreviousDisplay = {
      #     keyCode = 124;
      #     modifierFlags = 1310720;
      #   };
      #   restoreWindowComboKey = { };
      # };
    };
  };
}


# TODO: review these
# to_export = {
#     "ai.krisp.krispMac": global_rules,
#     "codes.rambo.AirBuddy": global_rules.and_rules(application="AirBuddy"),
#     "com.abhishek.Clocker": global_rules.and_rules(application="Clocker",
#                                                    exclusions=["iVersionLastChecked"]),
#     "com.apple.controlcenter": Rules(application="Control Center"),
#     "com.apple.dock": global_rules.and_rules(application="Dock", exclusions=[
#         "mod-count",
#         "trash-full",
#     ]),
#     "com.apple.finder": global_rules.and_rules(application="Finder", exclusions=[
#         "FXRecentFolders",
#         "FXSidebarUpgraded*",
#         "FavoriteTagNames",
#         "GoToField",
#         "GoToFieldHistory",
#         "LastTrashState",
#         "RecentMoveAndCopyDestinations",
#         "QuickLookPreview*",
#         "NewWindowTargetPath",
#         "FXPreferencesWindow..*"
#     ]),
#     "com.apple.screencapture": only(application="SystemUIServer", include=["location"]),
#     "com.apple.symbolichotkeys": None,
#     "com.googlecode.iterm2": global_rules,
#     "com.if.Amphetamine": Rules(application="Amphetamine", exclusions=[
#         "Session Durations",
#         "Total Session Run Time"
#     ]),
#     "com.omnigroup.OmniFocus3": global_rules.and_rules(exclusions=[
#         "LastArchiveRequestTimeInterval",
#         "LastAutomaticBackupDate",
#         "LastAutomaticBackupTailTransactionIdentifier",
#         "LastExportDirectory",
#     ]),
#     "com.sourcegear.DiffMerge": global_rules,
#     "com.surteesstudios.Bartender": only(application="Bartender 4", include=[
#         "SUAutomaticallyUpdate",
#         "ShowForUpdateSettings",
#         "ProfileSettings",
#         "UseBartenderBar",
#         "appSettings",
#         "statusBarImageNamed",
#         "license2HoldersName",
#         "license4HoldersName",
#        ]),
#     "org.shiftitapp.ShiftIt": global_rules.and_rules(application="ShiftIt"),
#     "com.apple.Safari": only(include=[
#         "AlwaysRestoreSessionAtLaunch",
#         "AutoFillPasswords",
#         "FindOnPageMatchesWordStartsOnly",
#         "HomePage",
#         "IncludeDevelopMenu",
#         "SearchProviderIdentifier",
#         "ShowFavoritesBar-v2",
#         "ShowOverlayStatusBar",
#         "ShowSidebarInNewWindows",
#         "ShowSidebarInTopSites",
#         "SidebarViewModeIdentifier",
#         "UniversalSearchEnabled",
#         "WebKitDeveloperExtrasEnabledPreferenceKey",
#         "WebKitPreferences.*",
#     ]),
#     "NSGlobalDomain": only(include=[
#         "AppleActionOnDoubleClick",
#         "AppleMiniaturizeOnDoubleClick",
#         "AppleScrollerPagingBehavior",
#         "AppleShowAllExtensions",
#         "NSAutomaticCapitalizationEnabled",
#         "NSAutomaticDashSubstitutionEnabled",
#         "NSAutomaticPeriodSubstitutionEnabled",
#         "NSAutomaticQuoteSubstitutionEnabled",
#         "NSAutomaticSpellingCorrectionEnabled",
#         "NSAutomaticTextCompletionEnabled",
#         "NSQuitAlwaysKeepsWindows",
#         "NSUserDictionaryReplacementItems",
#         "WebAutomaticSpellingCorrectionEnabled",
#         "com.apple.mouse.scaling",
#         "com.apple.sound.beep.flash",
#         "com.apple.sound.beep.volume",
#         "com.apple.sound.uiaudio.enabled",
#         "com.apple.springing.delay",
#         "com.apple.springing.enabled",
#         "com.apple.trackpad.forceClick",
#     ]),
#     "NSGlobalDomainCurrentHost": only(domain="NSGlobalDomain", current_host=True, include=[
#         "AppleActionOnDoubleClick",
#         "AppleAntiAliasingThreshold",
#         "AppleInterfaceStyle",
#         "AppleInterfaceStyleSwitchesAutomatically",
#         "AppleMiniaturizeOnDoubleClick",
#         "AppleScrollerPagingBehavior",
#         "AppleShowAllExtensions",
#         "NSAutomaticCapitalizationEnabled",
#         "NSAutomaticDashSubstitutionEnabled",
#         "NSAutomaticPeriodSubstitutionEnabled",
#         "NSAutomaticQuoteSubstitutionEnabled",
#         "NSAutomaticSpellingCorrectionEnabled",
#         "NSAutomaticTextCompletionEnabled",
#         "NSPreferredWebServices",
#         "NSQuitAlwaysKeepsWindows",
#         "WebAutomaticSpellingCorrectionEnabled",
#         "com.apple.mouse.scaling",
#         "com.apple.sound.beep.flash",
#         "com.apple.sound.beep.volume",
#         "com.apple.sound.uiaudio.enabled",
#         "com.apple.springing.delay",
#         "com.apple.springing.enabled",
#         "com.apple.trackpad.forceClick",
#     ]),
#     "com.agilebits.onepassword7": only(application="1Password 7", include=[
#         "OPPrefShowSafariInlineMenu",
#         "OPPrefShowSafariInlineMenuAutomatically",
#         "OPPreferencesNotifyCompromisedWebsites",
#         "ShortcutRecorder BrowserActivation",
#         "ShortcutRecorder GlobalActivation",
#         "ShortcutRecorder GlobalLock"
#     ]),
#     "net.shinyfrog.bear": only(application="Bear", include=[
#         "SFAppIconMatchesTheme",
#         "SFAppThemeName",
#         "SFAutoGrabURLTitles",
#         "SFEditorLineWidthMultiplier",
#         "SFFirstLaunchNotes",
#         "SFFoldCompletedTodo",
#         "SFNoteTextViewAutomaticSpellingCorrectionEnabled",
#         "SFNoteTextViewContinuousSpellCheckingEnabled",
#         "SFNoteTextViewGrammarCheckingEnabled",
#         "SFTagsListSortAscending",
#         "SFTagsListSortBy",
#     ])
# }

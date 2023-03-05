{ pkgs, ... }:
{
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

      "com.apple.dock" =
        {
          persistent-apps = "
      <array>
        <dict>
          <key>GUID</key>
          <integer>2340667429</integer>
          <key>tile-data</key>
          <dict>
            <key>book</key>
            <data>
            Ym9vaygCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAASAEAAAQAAAADAwAAAAAAIAwA
            AAABAQAAQXBwbGljYXRpb25zCQAAAAEBAABpVGVybS5h
            cHAAAAAIAAAAAQYAABAAAAAkAAAACAAAAAQDAABVPr0B
            AAAAAAgAAAAEAwAAVZ6+AQAAAAAIAAAAAQYAAEgAAABY
            AAAACAAAAAAEAABBwxseTAAAABgAAAABAgAAAgAAAAAA
            AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
            LwcAAAABAQAAQmlnIFN1cgAIAAAABAMAAABgRmQ6AAAA
            CAAAAAAEAABBwd5EgAAAACQAAAABAQAAN0VERjUxQTQt
            QjUzQy00REZBLTlBOTEtOEIyRTk5RDZCMzBBGAAAAAEC
            AACBAAAAAQAAAO8TAAABAAAAAAAAAAAAAAABAAAAAQEA
            AC8AAAAAAAAAAQUAAKgAAAD+////AQAAAAAAAAANAAAA
            BBAAADgAAAAAAAAABRAAAGgAAAAAAAAAEBAAAIgAAAAA
            AAAAQBAAAHgAAAAAAAAAAiAAADQBAAAAAAAABSAAAKgA
            AAAAAAAAECAAALgAAAAAAAAAESAAAOgAAAAAAAAAEiAA
            AMgAAAAAAAAAEyAAANgAAAAAAAAAICAAABQBAAAAAAAA
            MCAAAEABAAAAAAAAENAAAAQAAAAAAAAA
            </data>
            <key>bundle-identifier</key>
            <string>com.googlecode.iterm2</string>
            <key>dock-extra</key>
            <false/>
            <key>file-data</key>
            <dict>
              <key>_CFURLString</key>
              <string>file:///Applications/iTerm.app/</string>
              <key>_CFURLStringType</key>
              <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>iTerm</string>
            <key>file-mod-date</key>
            <integer>75157040831181</integer>
            <key>file-type</key>
            <integer>41</integer>
            <key>parent-mod-date</key>
            <integer>75960199715533</integer>
          </dict>
          <key>tile-type</key>
          <string>file-tile</string>
        </dict>
        <dict>
          <key>GUID</key>
          <integer>1970939019</integer>
          <key>tile-data</key>
          <dict>
            <key>book</key>
            <data>
            Ym9vaxgCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAOAEAAAQAAAADAwAAAAAAIAwA
            AAABAQAAQXBwbGljYXRpb25zCgAAAAEBAABTYWZhcmku
            YXBwAAAIAAAAAQYAABAAAAAkAAAACAAAAAQDAAB9oaoB
            AAAAAAgAAAAEAwAAf6GqAQAAAAAIAAAAAQYAAEgAAABY
            AAAACAAAAAAEAABBwd5EgAAAABgAAAABAgAAAgAAAAAA
            AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
            LwcAAAABAQAAQmlnIFN1cgAIAAAABAMAAABgRmQ6AAAA
            JAAAAAEBAAA3RURGNTFBNC1CNTNDLTRERkEtOUE5MS04
            QjJFOTlENkIzMEEYAAAAAQIAAIEAAAABAAAA7xMAAAEA
            AAAAAAAAAAAAAAEAAAABAQAALwAAAAAAAAABBQAAqAAA
            AP7///8BAAAAAAAAAA0AAAAEEAAAOAAAAAAAAAAFEAAA
            aAAAAAAAAAAQEAAAiAAAAAAAAABAEAAAeAAAAAAAAAAC
            IAAAJAEAAAAAAAAFIAAAqAAAAAAAAAAQIAAAuAAAAAAA
            AAARIAAA2AAAAAAAAAASIAAAyAAAAAAAAAATIAAAeAAA
            AAAAAAAgIAAABAEAAAAAAAAwIAAAMAEAAAAAAAAQ0AAA
            BAAAAAAAAAA=
            </data>
            <key>bundle-identifier</key>
            <string>com.apple.Safari</string>
            <key>dock-extra</key>
            <false/>
            <key>file-data</key>
            <dict>
              <key>_CFURLString</key>
              <string>file:///Applications/Safari.app/</string>
              <key>_CFURLStringType</key>
              <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>Safari</string>
            <key>file-mod-date</key>
            <integer>3660710400</integer>
            <key>file-type</key>
            <integer>41</integer>
            <key>parent-mod-date</key>
            <integer>116822518083132</integer>
          </dict>
          <key>tile-type</key>
          <string>file-tile</string>
        </dict>
        <dict>
          <key>GUID</key>
          <integer>1970939022</integer>
          <key>tile-data</key>
          <dict>
            <key>book</key>
            <data>
            Ym9va0ACAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAYAEAAAQAAAADAwAAAAAAIAYA
            AAABAQAAU3lzdGVtAAAMAAAAAQEAAEFwcGxpY2F0aW9u
            cwwAAAABAQAATWVzc2FnZXMuYXBwDAAAAAEGAAAQAAAA
            IAAAADQAAAAIAAAABAMAABUAAAD///8PCAAAAAQDAAAX
            AAAA////DwgAAAAEAwAAAY4AAP///w8MAAAAAQYAAFwA
            AABsAAAAfAAAAAgAAAAABAAAQcHeRIAAAAAYAAAAAQIA
            AAIAAAAAAAAADwAAAAAAAAAAAAAAAAAAAAgAAAABCQAA
            ZmlsZTovLy8HAAAAAQEAAEJpZyBTdXIACAAAAAQDAAAA
            YEZkOgAAACQAAAABAQAAN0VERjUxQTQtQjUzQy00REZB
            LTlBOTEtOEIyRTk5RDZCMzBBGAAAAAECAACBAAAAAQAA
            AO8TAAABAAAAAAAAAAAAAAABAAAAAQEAAC8AAAAAAAAA
            AQUAAKgAAAD+////AQAAAAAAAAANAAAABBAAAEgAAAAA
            AAAABRAAAIwAAAAAAAAAEBAAALAAAAAAAAAAQBAAAKAA
            AAAAAAAAAiAAAEwBAAAAAAAABSAAANAAAAAAAAAAECAA
            AOAAAAAAAAAAESAAAAABAAAAAAAAEiAAAPAAAAAAAAAA
            EyAAAKAAAAAAAAAAICAAACwBAAAAAAAAMCAAAFgBAAAA
            AAAAENAAAAQAAAAAAAAA
            </data>
            <key>bundle-identifier</key>
            <string>com.apple.MobileSMS</string>
            <key>dock-extra</key>
            <true/>
            <key>file-data</key>
            <dict>
              <key>_CFURLString</key>
              <string>file:///System/Applications/Messages.app/</string>
              <key>_CFURLStringType</key>
              <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>Messages</string>
            <key>file-mod-date</key>
            <integer>3660710400</integer>
            <key>file-type</key>
            <integer>41</integer>
            <key>parent-mod-date</key>
            <integer>3660710400</integer>
          </dict>
          <key>tile-type</key>
          <string>file-tile</string>
        </dict>
        <dict>
          <key>GUID</key>
          <integer>3173190601</integer>
          <key>tile-data</key>
          <dict>
            <key>book</key>
            <data>
            Ym9vaywCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAATAEAAAQAAAADAwAAAAAAIAwA
            AAABAQAAQXBwbGljYXRpb25zDQAAAAEBAABPbW5pRm9j
            dXMuYXBwAAAACAAAAAEGAAAQAAAAJAAAAAgAAAAEAwAA
            VT69AQAAAAAIAAAABAMAADWsoAEAAAAACAAAAAEGAABM
            AAAAXAAAAAgAAAAABAAAQcMP7V6AAAAYAAAAAQIAAAIA
            AAAAAAAADwAAAAAAAAAAAAAAAAAAAAgAAAABCQAAZmls
            ZTovLy8HAAAAAQEAAEJpZyBTdXIACAAAAAQDAAAAYEZk
            OgAAAAgAAAAABAAAQcHeRIAAAAAkAAAAAQEAADdFREY1
            MUE0LUI1M0MtNERGQS05QTkxLThCMkU5OUQ2QjMwQRgA
            AAABAgAAgQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAA
            AAEBAAAvAAAAAAAAAAEFAACoAAAA/v///wEAAAAAAAAA
            DQAAAAQQAAA8AAAAAAAAAAUQAABsAAAAAAAAABAQAACM
            AAAAAAAAAEAQAAB8AAAAAAAAAAIgAAA4AQAAAAAAAAUg
            AACsAAAAAAAAABAgAAC8AAAAAAAAABEgAADsAAAAAAAA
            ABIgAADMAAAAAAAAABMgAADcAAAAAAAAACAgAAAYAQAA
            AAAAADAgAABEAQAAAAAAABDQAAAEAAAAAAAAAA==
            </data>
            <key>bundle-identifier</key>
            <string>com.omnigroup.OmniFocus3</string>
            <key>dock-extra</key>
            <false/>
            <key>file-data</key>
            <dict>
              <key>_CFURLString</key>
              <string>file:///Applications/OmniFocus.app/</string>
              <key>_CFURLStringType</key>
              <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>OmniFocus</string>
            <key>file-mod-date</key>
            <integer>3700773821</integer>
            <key>file-type</key>
            <integer>41</integer>
            <key>parent-mod-date</key>
            <integer>75960199715533</integer>
          </dict>
          <key>tile-type</key>
          <string>file-tile</string>
        </dict>
        <dict>
          <key>GUID</key>
          <integer>92044080</integer>
          <key>tile-data</key>
          <dict>
            <key>book</key>
            <data>
            Ym9vaygCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAASAEAAAQAAAADAwAAAAAAIAwA
            AAABAQAAQXBwbGljYXRpb25zCQAAAAEBAABTbGFjay5h
            cHAAAAAIAAAAAQYAABAAAAAkAAAACAAAAAQDAABVPr0B
            AAAAAAgAAAAEAwAAx0rAAQAAAAAIAAAAAQYAAEgAAABY
            AAAACAAAAAAEAABBwx5AKAAAABgAAAABAgAAAgAAAAAA
            AAAPAAAAAAAAAAAAAAAAAAAACAAAAAEJAABmaWxlOi8v
            LwcAAAABAQAAQmlnIFN1cgAIAAAABAMAAABgRmQ6AAAA
            CAAAAAAEAABBwd5EgAAAACQAAAABAQAAN0VERjUxQTQt
            QjUzQy00REZBLTlBOTEtOEIyRTk5RDZCMzBBGAAAAAEC
            AACBAAAAAQAAAO8TAAABAAAAAAAAAAAAAAABAAAAAQEA
            AC8AAAAAAAAAAQUAAKgAAAD+////AQAAAAAAAAANAAAA
            BBAAADgAAAAAAAAABRAAAGgAAAAAAAAAEBAAAIgAAAAA
            AAAAQBAAAHgAAAAAAAAAAiAAADQBAAAAAAAABSAAAKgA
            AAAAAAAAECAAALgAAAAAAAAAESAAAOgAAAAAAAAAEiAA
            AMgAAAAAAAAAEyAAANgAAAAAAAAAICAAABQBAAAAAAAA
            MCAAAEABAAAAAAAAENAAAAQAAAAAAAAA
            </data>
            <key>bundle-identifier</key>
            <string>com.tinyspeck.slackmacgap</string>
            <key>dock-extra</key>
            <false/>
            <key>file-data</key>
            <dict>
              <key>_CFURLString</key>
              <string>file:///Applications/Slack.app/</string>
              <key>_CFURLStringType</key>
              <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>Slack</string>
            <key>file-mod-date</key>
            <integer>3702651216</integer>
            <key>file-type</key>
            <integer>41</integer>
            <key>parent-mod-date</key>
            <integer>13425475979525</integer>
          </dict>
          <key>tile-type</key>
          <string>file-tile</string>
        </dict>
      </array>
      ";
          persistent-others = "
      <array>
        <dict>
          <key>GUID</key>
          <integer>3299841160</integer>
          <key>tile-data</key>
          <dict>
            <key>arrangement</key>
            <integer>1</integer>
            <key>book</key>
            <data>
            Ym9va/gBAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAADAEAAAQAAAADAwAAAAAAIAwA
            AAABAQAAQXBwbGljYXRpb25zBAAAAAEGAAAQAAAACAAA
            AAQDAADZXwoBAAAAAAQAAAABBgAAMAAAAAgAAAAABAAA
            QcHeRIAAAAAYAAAAAQIAAAIAAAAAAAAADwAAAAAAAAAA
            AAAAAAAAAAAAAAABBQAACAAAAAEJAABmaWxlOi8vLwcA
            AAABAQAAQmlnIFN1cgAIAAAABAMAAABgRmQ6AAAAJAAA
            AAEBAAA3RURGNTFBNC1CNTNDLTRERkEtOUE5MS04QjJF
            OTlENkIzMEEYAAAAAQIAAIEAAAABAAAA7xMAAAEAAAAA
            AAAAAAAAAAEAAAABAQAALwAAALQAAAD+////AQAAAAAA
            AAAOAAAABBAAACQAAAAAAAAABRAAAEAAAAAAAAAAEBAA
            AFwAAAAAAAAAQBAAAEwAAAAAAAAAAiAAAAABAAAAAAAA
            BSAAAIQAAAAAAAAAECAAAJQAAAAAAAAAESAAALQAAAAA
            AAAAEiAAAKQAAAAAAAAAEyAAAEwAAAAAAAAAICAAAOAA
            AAAAAAAAMCAAAHwAAAAAAAAAAdAAAHwAAAAAAAAAENAA
            AAQAAAAAAAAA
            </data>
            <key>displayas</key>
            <integer>0</integer>
            <key>file-data</key>
            <dict>
              <key>_CFURLString</key>
              <string>file:///Applications/</string>
              <key>_CFURLStringType</key>
              <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>Applications</string>
            <key>file-mod-date</key>
            <integer>136682396282674</integer>
            <key>file-type</key>
            <integer>2</integer>
            <key>parent-mod-date</key>
            <integer>223372015311351</integer>
            <key>preferreditemsize</key>
            <integer>-1</integer>
            <key>showas</key>
            <integer>0</integer>
          </dict>
          <key>tile-type</key>
          <string>directory-tile</string>
        </dict>
        <dict>
          <key>GUID</key>
          <integer>1970939036</integer>
          <key>tile-data</key>
          <dict>
            <key>arrangement</key>
            <integer>2</integer>
            <key>book</key>
            <data>
            Ym9va4wCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAiAEAAAQAAAADAwAAAAAAIAUA
            AAABAQAAVXNlcnMAAAAHAAAAAQEAAHNoZWVsZXkACQAA
            AAEBAABEb3dubG9hZHMAAAAMAAAAAQYAABAAAAAgAAAA
            MAAAAAgAAAAEAwAAPWsAAAAAAAAIAAAABAMAAImUAAAA
            AAAACAAAAAQDAACu/QcAAAAAAAwAAAABBgAAWAAAAGgA
            AAB4AAAACAAAAAAEAABBwVOc/AAAABgAAAABAgAAAgAA
            AAAAAAAPAAAAAAAAAAAAAAAAAAAACAAAAAQDAAABAAAA
            AAAAAAQAAAADAwAA9QEAAAgAAAABCQAAZmlsZTovLy8H
            AAAAAQEAAEJpZyBTdXIACAAAAAQDAAAAYEZkOgAAAAgA
            AAAABAAAQcHeRIAAAAAkAAAAAQEAADdFREY1MUE0LUI1
            M0MtNERGQS05QTkxLThCMkU5OUQ2QjMwQRgAAAABAgAA
            gQAAAAEAAADvEwAAAQAAAAAAAAAAAAAAAQAAAAEBAAAv
            AAAAAAAAAAEFAADMAAAA/v///wEAAAAAAAAAEAAAAAQQ
            AABEAAAAAAAAAAUQAACIAAAAAAAAABAQAACsAAAAAAAA
            AEAQAACcAAAAAAAAAAIgAAB0AQAAAAAAAAUgAADoAAAA
            AAAAABAgAAD4AAAAAAAAABEgAAAoAQAAAAAAABIgAAAI
            AQAAAAAAABMgAAAYAQAAAAAAACAgAABUAQAAAAAAADAg
            AACAAQAAAAAAAAHAAADMAAAAAAAAABHAAAAgAAAAAAAA
            ABLAAADcAAAAAAAAABDQAAAEAAAAAAAAAA==
            </data>
            <key>displayas</key>
            <integer>0</integer>
            <key>file-data</key>
            <dict>
              <key>_CFURLString</key>
              <string>file://~/Downloads/</string>
              <key>_CFURLStringType</key>
              <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>Downloads</string>
            <key>file-mod-date</key>
            <integer>280396296009339</integer>
            <key>file-type</key>
            <integer>2</integer>
            <key>parent-mod-date</key>
            <integer>159312578091094</integer>
            <key>preferreditemsize</key>
            <integer>-1</integer>
            <key>showas</key>
            <integer>1</integer>
          </dict>
          <key>tile-type</key>
          <string>directory-tile</string>
        </dict>
        <dict>
          <key>GUID</key>
          <integer>3949007290</integer>
          <key>tile-data</key>
          <dict>
            <key>arrangement</key>
            <integer>1</integer>
            <key>book</key>
            <data>
            Ym9va5gCAAAAAAQQMAAAAAAAAAAAAAAAAAAAAAAAAAAA
            AAAAAAAAAAAAAAAAAAAAiAEAAAQAAAADAwAAAAAAIAUA
            AAABAQAAVXNlcnMAAAAHAAAAAQEAAHNoZWVsZXkACwAA
            AAEBAABTY3JlZW5zaG90cwAMAAAAAQYAABAAAAAgAAAA
            MAAAAAgAAAAEAwAAPWsAAAAAAAAIAAAABAMAAImUAAAA
            AAAACAAAAAQDAACN1q8AAAAAAAwAAAABBgAAWAAAAGgA
            AAB4AAAACAAAAAAEAABBwo84iepkgRgAAAABAgAAAgAA
            AAAAAAAPAAAAAAAAAAAAAAAAAAAAAAAAAAEFAAAIAAAA
            BAMAAAEAAAAAAAAABAAAAAMDAAD1AQAACAAAAAEJAABm
            aWxlOi8vLwcAAAABAQAAQmlnIFN1cgAIAAAABAMAAABg
            RmQ6AAAACAAAAAAEAABBwd5EgAAAACQAAAABAQAAN0VE
            RjUxQTQtQjUzQy00REZBLTlBOTEtOEIyRTk5RDZCMzBB
            GAAAAAECAACBAAAAAQAAAO8TAAABAAAAAAAAAAAAAAAB
            AAAAAQEAAC8AAADYAAAA/v///wEAAAAAAAAAEQAAAAQQ
            AABEAAAAAAAAAAUQAACIAAAAAAAAABAQAACsAAAAAAAA
            AEAQAACcAAAAAAAAAAIgAAB8AQAAAAAAAAUgAADwAAAA
            AAAAABAgAAAAAQAAAAAAABEgAAAwAQAAAAAAABIgAAAQ
            AQAAAAAAABMgAAAgAQAAAAAAACAgAABcAQAAAAAAADAg
            AADMAAAAAAAAAAHAAADUAAAAAAAAABHAAAAgAAAAAAAA
            ABLAAADkAAAAAAAAAAHQAADMAAAAAAAAABDQAAAEAAAA
            AAAAAA==
            </data>
            <key>displayas</key>
            <integer>0</integer>
            <key>file-data</key>
            <dict>
              <key>_CFURLString</key>
              <string>file://~/Screenshots/</string>
              <key>_CFURLStringType</key>
              <integer>15</integer>
            </dict>
            <key>file-label</key>
            <string>Screenshots</string>
            <key>file-mod-date</key>
            <integer>66438238144822</integer>
            <key>file-type</key>
            <integer>2</integer>
            <key>parent-mod-date</key>
            <integer>233972027353619</integer>
            <key>preferreditemsize</key>
            <integer>-1</integer>
            <key>showas</key>
            <integer>0</integer>
          </dict>
          <key>tile-type</key>
          <string>directory-tile</string>
        </dict>
      </array>
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

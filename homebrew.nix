{
  # pkgs,
  lib,
  private,
  ...
}:
# let
# in
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # use "uninstall" if you want nix to manage everything; zap removes configuration and cache also.
      # cleanup = "uninstall";
      upgrade = true;
    };

    brews =
      [
        "git-delta"
        "swiftformat"
      ]
      ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
        "dovecot"
      ]);

    casks =
      [
        "1password"
        "1password/tap/1password-cli"
        # "eloston-chromium"
        "ghostty"
        "iterm2"
        # "little-snitch"
        "obsidian"
        "shortcat"
        "slack"
      ]
      ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
        "whisky"
      ]);

    masApps = {
      "1Password Safari" = 1569813296;
      "Actions" = 1586435171;
      "Amphetamine" = 937984704;
      "Clocker" = 1056643111;
      "Expressions" = 913158085;
      "iA Writer" = 775737590;
      "Kagi" = 1622835804;
      "Magnet" = 441258766;
      "Patterns" = 429449079;
      "Peek" = 1554235898;
      "Pure Paste" = 1611378436;
      "Reeder" = 1529448980;
      "Remove Web Limits" = 1626843895;
      "Sim Daltonism" = 693112260;
      "Space Gremlin" = 414515628;
      "The Unarchiver" = 425424353;
      "Watchdog" = 734258109;
      # "Xcode" = 497799835;
      "Logger for Shortcuts" = 1611554653;
    };

    taps = [
      "1password/tap"
    ];
  };
}

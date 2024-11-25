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
      cleanup = "uninstall"; # use "uninstall" if you want to manage everything; zap removes configuration and cache also.
      upgrade = true;
    };

    brews =
      [
        # "ds"
        "git-delta"
        # "n" # node version manager
        # "scout"
        "swiftformat"
      ]
      ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
        "dovecot"
      ]);

    casks =
      [
        "1password"
        # TODO: this constantly updates
        "1password/tap/1password-cli"
        # "eloston-chromium"
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
      "Space Gremlin" = 414515628;
      "The Unarchiver" = 425424353;
      "Watchdog" = 734258109;
      # "Xcode" = 497799835;
      "Logger for Shortcuts" = 1611554653;
    };

    taps = [
      "1password/tap"
      # "abridoux/formulae"
      # "aerobounce/tap"
      # "homebrew/bundle"
    ];
  };
}

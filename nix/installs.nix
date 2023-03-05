{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;

    brews = [
      "borgmatic"
      "git-delta"
      "swiftformat"
      "swiftlint"
    ];

    casks = [
      "1password"
      "1password-cli"
      "bartender"
      "diffmerge"
      "iterm2"
      "shortcat"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Clocker" = 1056643111;
      "Expressions" = 913158085;
      "iA Writer" = 775737590;
      "Magnet" = 441258766;
      "Patterns" = 429449079;
      "Pure Paste" = 1611378436;
      "Reeder" = 1529448980;
      "Space Gremlin" = 414515628;
      "The Unarchiver" = 425424353;
      "Watchdog" = 734258109;
      # TODO "Xcode" = 497799835;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/core"
    ];

    # TODO: tuist?
  };
}

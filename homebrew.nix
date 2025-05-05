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

    global = {
      autoUpdate = false;
    };

    onActivation = {
      autoUpdate = true;
      # use "uninstall" if you want nix to manage everything; zap removes configuration and cache also.
      # cleanup = "uninstall";
      # upgrade = true;
    };

    brews =
      [
        "git-delta"
        "swiftformat"
        "touch2sudo"
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

    taps = [
      "1password/tap"
      "prbinu/touch2sudo"
    ];
  };
}

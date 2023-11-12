{
  lib,
  pkgs,
  user,
  private,
  ...
}: let
in {
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    zsh
  ];

  users.users.${user} = {
    # FUTURE: nix-darwin can't manage login shell yet
    shell = pkgs.zsh;
    name = user;
    home = "/Users/${user}";
  };

  fonts.fontDir = {
    enable = true;
  };

  fonts.fonts = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;
  # TODO: security.pam.touchIdAuth = true;

  services.tailscale = {
    enable = true;
  };

  system.activationScripts = {
    preActivation.text = ''
      DIRS=(
      	"$HOME/.ssh/control"
      	"$HOME/Screenshots"
      	"$HOME/projects/sheeley"
      	"$HOME/bin"
      	"$HOME/scratch"
      )
      for DIR in "''${DIRS[@]}"; do
      	mkdir -p "$DIR"
      	chown -R ${user} "$DIR"
      done
    '';

    postActivation.text = builtins.replaceStrings ["@tailscaleKey@"] ["${private.tailscaleKey}"] (lib.concatStrings (
      map
      (fileName: builtins.readFile (./scripts + "/${fileName}"))
      [
        "magnet.sh"
        "iterm2.sh"
      ]
      ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
        # personal only
        "tailscale.sh"
      ])
      ++ ((lib.optionals (lib.hasAttr "homebase" private && private.homebase)) [
        # homebase only
        "content-cache.sh"
      ])
    ));
  };
}

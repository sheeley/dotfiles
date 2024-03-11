{
  lib,
  pkgs,
  user,
  private,
  ...
}: let
  readFile = fileName:
    "\n# BEGIN: ${fileName}\n"
    # + (builtins.replaceStrings ["@tailscaleKey@"] ["${private.tailscaleKey}"]
    + (builtins.readFile fileName)
    + "\n# END: ${fileName}\n\n";
in {
  imports =
    [
    ]
    ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
      # personal only
      ./programs/tailscale.nix
    ]);
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

    # postActivation.text = lib.concatStrings (
    #   map (fileName: readFile (./scripts + "/${fileName}"))
    #   [
    #     "clocker.bash"
    #     "magnet.bash"
    #   ]
    # );
  };
}

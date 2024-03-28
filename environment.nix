{
  lib,
  pkgs,
  user,
  private,
  ...
}: let
  #   readFile = fileName:
  #     "\n# BEGIN: ${fileName}\n"
  #     # + (builtins.replaceStrings ["@tailscaleKey@"] ["${private.tailscaleKey}"]
  #     + (builtins.readFile fileName)
  #     + "\n# END: ${fileName}\n\n";
  prefix =
    if pkgs.system == "aarch64-darwin"
    then "Users"
    else "home";
in {
  imports =
    [
    ]
    ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
      # personal only
      # TODO: bring back
      # ./programs/tailscale.nix
    ]);
  users.users.${user} = {
    # TODO: nix-darwin can't manage login shell yet
    shell = pkgs.fish;
    name = user;
    home = "/${prefix}/${user}";
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    zsh
  ];

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

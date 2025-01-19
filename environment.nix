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
  homeDir = "/${prefix}/${user}";
in {
  imports =
    [
    ]
    ++ ((lib.optionals (lib.hasAttr "personal" private && private.personal)) [
      # personal only
      # ./programs/tailscale.nix - if desired again
    ]);
  users.users.${user} = {
    shell = pkgs.fish;
    name = user;
    home = homeDir;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKE2WdU/DUu3rEshA4cns8QWzVzy9bsFgb+7HR4jBixF"
    ];
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    zsh
  ];

  # services.tailscale = {
  #   enable = true;
  # };

  system.activationScripts = {
    preActivation.text = ''
      DIRS=(
      	"${homeDir}/.ssh/control"
      	"${homeDir}/Screenshots"
      	"${homeDir}/projects/sheeley"
      	"${homeDir}/bin"
      	"${homeDir}/scratch"
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

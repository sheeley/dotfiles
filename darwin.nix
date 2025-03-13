{
  pkgs,
  user,
  ...
}: let
  cacheHost = "tiny.sheeley.house";
in {
  imports = [
    ./dock.nix
  ];
  system = {
    stateVersion = 5;
  };
  # necessary for mba for some reason
  # ids.gids.nixbld = 30000;

  nix = {
    settings = {
      # Add substituter for local cache
      substituters = ["http://${cacheHost}"];
      # "http://192.168.1.17"];

      # extra-nix-path = "nixpkgs=flake:nixpkgs";
    };

    extraOptions = ''
      # nix fails on the _first_ failure instead of falling back by default
        # Ensure we can still build when missing-server is not accessible
        fallback = true
    '';
  };

  home-manager.users.${user} = {...}: {
    home.packages = [
      # pkgs.obsidian
    ];

    programs.ssh = {
      extraConfig = ''
        # Ensure the local cache fails fast so fallback can happen
        Host ${cacheHost}
            ConnectTimeout 3
      '';
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.fira-mono
    pkgs.nerd-fonts.fira-code
  ];
  # to turn all on:
  # fonts.packages = [ ... ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)

  #system.keyboard.enableKeyMapping = true;
  security.pam.services.sudo_local.touchIdAuth = true;
}

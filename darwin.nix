{
  pkgs,
  user,
  ...
}: {
  # TODO: this currently rebuilds swift-5.8 every time
  # disabling until that is resolved.
  # imports = [
  #   ./dock.nix
  # ];
  system = {
    stateVersion = 5;
  };

  nix = {
    settings = {
      # Add substituter for local cache
      substituters = ["http://nix-cache.aigee.org"];
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
      # TODO: see above
      # pkgs.dockutil
      pkgs.obsidian
    ];

    programs.ssh = {
      extraConfig = ''
        # Ensure the local cache fails fast so fallback can happen
        Host lab.aigee.org
            ConnectTimeout 3
      '';
    };
  };

  services.nix-daemon.enable = true;

  fonts.packages = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;
}

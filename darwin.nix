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

  # Add substituter for local cache
  nix.settings.substituters = ["http://nix-cache.aigee.org"];

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

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

  home-manager.users.${user} = {...}: {
    home.packages = [
      # pkgs.dockutil
      pkgs.obsidian
    ];
  };

  nix.settings.substituters = ["http://lab.aigee.org"];
  services.nix-daemon.enable = true;

  fonts.packages = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;
}

{pkgs, ...}: {
  imports = [
    ./dock.nix
  ];

  services.nix-daemon.enable = true;

  fonts.packages = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;
}

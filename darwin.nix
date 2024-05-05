{pkgs, ...}: {
  imports = [
    ./dock.nix
  ];

  services.nix-daemon.enable = true;

  fonts.fontDir = {
    enable = true;
  };

  fonts.fonts = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;
}

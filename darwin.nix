{pkgs, ...}: {
    services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  
  fonts.fontDir = {
    enable = true;
  };

  fonts.fonts = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;
}

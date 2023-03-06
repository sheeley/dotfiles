{ pkgs, ... }:
{
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish zsh ];
  # users.defaultUserShell = pkgs.fish;
  users.users.sheeley = {
    shell = pkgs.fish;
    name = "sheeley";
    home = "/Users/sheeley";
  };

  # fonts.enableFontDir = true;
  fonts.fonts = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;
}

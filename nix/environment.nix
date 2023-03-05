{ pkgs, ... }:
{
  services.nix-daemon.enable = true;

  environment.shells = [ pkgs.fish ];

  fonts.fonts = [
    pkgs.nerdfonts
  ];
}

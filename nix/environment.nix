{ pkgs, ... }:
{
  services.nix-daemon.enable = true;

  environment.shells = [ pkgs.fish ];
  users.users.sheeley.shell = pkgs.fish;

  fonts.fonts = [
    pkgs.nerdfonts
  ];
}

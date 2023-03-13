{ pkgs, ... }:
let
  private = pkgs.callPackage ~/.nix-private/private.nix { };
  # TODO: dynamic
  user = "johnnysheeley";
in
{
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish zsh ];

  users.users.${user} = {
    # TODO: figure out how to correctly set default shell
    shell = pkgs.zsh;
    name = user;
    home = "/Users/${user}";
  };

  # environment.systemPackages = [
  #   pkgs.nixpkgs-fmt
  # ];

  # fonts.enableFontDir = true;
  fonts.fonts = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;

  # TODO:
  # "/opt/homebrew/etc/dovecot/dovecot.conf".source = ./files/dovecot.conf;
}

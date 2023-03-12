{ pkgs, ... }:
let user = "sheeley";
in
{
  services.nix-daemon.enable = true;

  environment.shells = with pkgs; [ fish zsh ];

  users.users.${user} = {
    # BUMMER: shell needs to be set manually on darwin
    # shell = pkgs.zsh;
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

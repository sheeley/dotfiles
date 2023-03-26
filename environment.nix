{
  pkgs,
  user,
  private,
  ...
}: let
in {
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    zsh
  ];

  users.users.${user} = {
    # FUTURE: nix-darwin can't manage login shell yet
    shell = pkgs.zsh;
    name = user;
    home = "/Users/${user}";
  };

  # fonts.enableFontDir = true;
  fonts.fonts = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;

  # TODO: configure dovecot
  environment.etc."dovecot.conf".source = ./files/dovecot.conf;

  system.activationScripts = {
    preActivation.source = ./pre.sh;
    postActivation.source = ./post.sh;
  };
}

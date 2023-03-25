{
  pkgs,
  user,
  ...
}: let
  private = pkgs.callPackage ~/.nix-private/private.nix {};
in {
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    zsh
  ];

  users.users.${user} = {
    # TODO: nix-darwin can't manage login shell yet
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

  # TODO:
  environment.etc."dovecot.conf".source = ./files/dovecot.conf;

  system.activationScripts = {
    preActivation.text = ''
      mkdir -p "$HOME/.ssh/control"
      mkdir -p "$HOME/Screenshots"
      mkdir -p "$HOME/projects/sheeley"
      mkdir -p "$HOME/bin"
      mkdir -p "$HOME/scratch"
      mkdir -p "$HOME/scratch"
    '';

    # postActivation.text = ''
    # (
    #   cd ./tools/meeting-notes
    #   ./install
    # )
  };
}

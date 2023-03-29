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

  system.activationScripts = {
    preActivation.text = ''
      DIRS=(
      	"$HOME/.ssh/control"
      	"$HOME/Screenshots"
      	"$HOME/projects/sheeley"
      	"$HOME/bin"
      	"$HOME/scratch"
      )
      for DIR in "''${DIRS[@]}"; do
      	mkdir -p "$DIR"
      	chown -R ${user} "$DIR"
      done
    '';

    # postActivation.text = ''
    #   (
    #   	cd ./tools/meeting-notes
    #   	./install
    #   )
    # '';
  };
}

{
  pkgs,
  private,
  user,
  ...
}: let
  homeDirectory = "/Users/sheeley";
in {
  # homebrew.brews = [
  #   "borgbackup"
  #   "borgmatic"
  # ];
  # homebrew.brews = ["kind"];

  home-manager.users.${user} = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home = {
      packages = with pkgs; [
        borgmatic
      ];

      file.".config/borgmatic/config.yaml".source = pkgs.substituteAll {
        name = "config.yaml";
        src = ../files/borgmatic/config.yaml;
        secret = "${private.borgSecret}";
        user = "${private.borgUser}";
      };
    };
  };

  # automatically run borgmatic and other housekeeping work
  launchd.agents.housekeeping = {
    script = "
    su ${user}
    housekeeping
    mail -s \"Housekeeping Output\" sheeley@aigee.org < /tmp/housekeeping.log
    ";

    path = [
      "/bin"
      "/usr/bin"
      "/usr/sbin"
      "/etc/profiles/per-user/${user}/bin"
      "/Users/${user}/dotfiles/bin"
      "/opt/homebrew/bin"
    ];

    environment = {
      BORG_REPO = "/Volumes/money/borgbackup";
      HOME = "/Users/${user}";
      PRIVATE_TOOLS_DIR = "${homeDirectory}/projects/sheeley/infrastructure";
      WORKMACHINE = "false";
    };

    serviceConfig = {
      Label = "housekeeping";
      ProcessType = "Background";
      # ProgramArguments = [
      #   "/Users/${user}/dotfiles/bin/housekeeping"
      # ];
      StandardOutPath = "/tmp/housekeeping.log";
      StandardErrorPath = "/tmp/housekeeping.log";
      StartCalendarInterval = [
        {
          Hour = 1;
        }
      ];
      UserName = "${user}";
    };
  };

  system.activationScripts.postUserActivation.text = builtins.readFile ./content-cache.bash;
}

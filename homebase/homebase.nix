{
  pkgs,
  private,
  user,
  ...
}: let
  homeDirectory = "/Users/sheeley";
in {
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

      # TODO: set this up
      #       file.".smtp.json".source = ""
      # {
      # 	"hostname": "",
      # 	"email": "",
      # 	"password": ""
      # }
      #
      #         "";
    };
  };

  # automatically run borgmatic and other housekeeping work
  launchd.agents.housekeeping = {
    script = "
    housekeeping
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
      TOOLS_DIR = "/Users/${user}/dotfiles/bin";
      PRIVATE_TOOLS_DIR = "${homeDirectory}/projects/sheeley/infrastructure";
      WORKMACHINE = "false";
    };

    serviceConfig = {
      Label = "org.aigee.housekeeping";
      ProcessType = "Background";
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

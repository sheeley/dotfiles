{
  # pkgs,
  private,
  storagePath,
  user,
  ...
}: let
  homeDirectory = "/Users/sheeley";
in {
  homebrew.casks = [
    "utm"
  ];
  home-manager.users.${user} = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home = {
      packages = with pkgs; [
        borgmatic
        # utm
      ];

      sessionVariables = {
        BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
        BORG_REPO = "${storagePath}/borgbackup";
        BORG_EXIT_CODES = "modern";
      };

      # Supposed to be better, but I couldn't get it to replace all of the vars
      # file.".config/borgmatic/config.yaml".source = pkgs.replaceVars ../files/borgmatic/config.yaml {
      #   secret = "${private.borgSecret}";
      #   user = "${private.borgUser}";
      #   storagePath = "${storagePath}";
      # };

      file.".config/borgmatic/config.yaml".source = pkgs.substituteAll {
        name = "config.yaml";
        src = ../files/borgmatic/config.yaml;

        secret = "${private.borgSecret}";
        user = "${private.borgUser}";
        storagePath = "${storagePath}";
      };

      file.".smtp.json".text = ''
        {
        	"hostname": "${private.emailHostname}",
        	"email": "${private.email}",
        	"password": "${private.emailPassword}"
        }
      '';
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
      "${homeDirectory}/dotfiles/bin"
      "${homeDirectory}/bin"
      "/opt/homebrew/bin"
    ];

    environment = {
      BORG_REPO = "${storagePath}/borgbackup";
      HOME = homeDirectory;
      TOOLS_DIR = "${homeDirectory}/dotfiles/bin";
      PRIVATE_TOOLS_DIR = "${homeDirectory}/projects/sheeley/infrastructure";
      WORKMACHINE = "false";
    };

    serviceConfig = {
      Label = "org.aigee.housekeeping";
      ProcessType = "Background";
      StandardOutPath = "/tmp/housekeeping.txt";
      StandardErrorPath = "/tmp/housekeeping.txt";
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

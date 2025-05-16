{
  # pkgs,
  # config,
  lib,
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
      ];

      sessionVariables = {
        BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
        BORG_REPO = "${storagePath}/borgbackup";
        BORG_EXIT_CODES = "modern";
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

  # https://github.com/nix-darwin/nix-darwin/issues/1255
  # automatically run borgmatic and other housekeeping work
  launchd.daemons.housekeeping = {
    script = "
      housekeeping
      ";

    path = import ../environment_path.nix {inherit user homeDirectory;};

    environment =
      import ../environment_variables.nix {
        inherit homeDirectory lib private;
      }
      # // merges dictionaries. Ugh.
      // {
        BORG_REPO = "${storagePath}/borgbackup";
        HOME = homeDirectory;
      };

    serviceConfig = {
      Label = "org.aigee.housekeeping";
      ProcessType = "Background";
      StandardOutPath = "/tmp/housekeeping.txt";
      StandardErrorPath = "/tmp/housekeeping.err.txt";
      UserName = "${user}";
      StartCalendarInterval = [
        {
          Hour = 1;
        }
      ];
    };
  };
}

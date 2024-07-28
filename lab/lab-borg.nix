{
  pkgs,
  private,
  user,
  ...
}: {
  services.borgbackup.jobs.homelab = {
    paths = [
      # /mnt/Media
      (builtins.toString /mnt/Media)
    ];
    exclude = [
      "lost+found"
    ];
    encryption = {
      mode = "repokey";
      passphrase = private.borgSecret;
    };
    user = user;
    repo = "ssh://${private.borgUser}@${private.borgUser}.repo.borgbase.com/./repo";
    compression = "auto,zstd";
    startAt = "daily";
  };

  # home-manager.users.${user} = {
  #   home.packages = [
  #     pkgs.borgmatic
  #   ];
  #
  #   programs.borgmatic = {
  #     enable = true;
  #
  #     backups = {
  #       lab = {
  #         location = {
  #           repositories = [
  #             "ssh://${private.borgUser}@${private.borgUser}.repo.borgbase.com/./repo"
  #           ];
  #
  #           sourceDirectories = [
  #             "/mnt/Media"
  #             "/home/${user}"
  #           ];
  #
  #           excludeHomeManagerSymlinks = true;
  #         };
  #
  #         retention = {
  #           keepDaily = 7;
  #           keepMonthly = 3;
  #           keepWeekly = 4;
  #           keepYearly = 3;
  #         };
  #
  #         storage.encryptionPasscommand = "echo ${private.borgSecret}";
  #
  #         consistency.checks = [
  #           {
  #             name = "repository";
  #             frequency = "2 weeks";
  #           }
  #           {
  #             name = "archives";
  #             frequency = "4 weeks";
  #           }
  #           {
  #             name = "data";
  #             frequency = "6 weeks";
  #           }
  #           {
  #             name = "extract";
  #             frequency = "6 weeks";
  #           }
  #         ];
  #       };
  #     };
  #   };
  #
  #   systemd.user.services.borgmatic = {
  #     serviceConfig = {
  #       Type = "oneshot";
  #       ExecStart = "${pkgs.borgmatic}/bin/borgmatic --verbosity 1";
  #     };
  #
  #     timerConfig = {
  #       OnCalendar = "daily";
  #       Persistent = true;
  #     };
  #
  #     # wantedBy = ["timers.target"];
  #   };
  # };
}

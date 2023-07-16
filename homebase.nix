{
  pkgs,
  lib,
  private,
  user,
  ...
}: let
in {
  homebrew.brews = [
    "borgbackup"
    "borgmatic"
  ];

  home-manager.users.${user} = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home.file.".config/borgmatic/config.yaml".source = pkgs.substituteAll {
      name = "config.yaml";
      src = ./files/borgmatic/config.yaml;
      secret = "${private.borgSecret}";
      user = "${private.borgUser}";
    };
  };

  # TODO: set up automatic borgmatic
  #   launchd.agents.borgmatic = {
  #     command = "/opt/homebrew/bin/borgmatic";
  #     Label = "borgmatic"
  #   };

  # launchd.user.agents.fetch-nixpkgs-updates = {
  #   command = "/usr/bin/sandbox-exec -f ${config.security.sandbox.profiles.fetch-nixpkgs-updates.profile} ${pkgs.git}/bin/git -C ${toString ~/Code/nixos/nixpkgs} fetch origin master";
  #   environment.HOME = "";
  #   environment.NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  #   serviceConfig.KeepAlive = false;
  #   serviceConfig.ProcessType = "Background";
  #   serviceConfig.StartInterval = 360;
  # };
  #   <key>RunAtLoad</key>
  # 	<true/>
  # 	<key>StandardErrorPath</key>
  # 	<string>/Users/wtraylor/logs/borgrun/borgmatic.err</string>
  # 	<key>StandardOutPath</key>
  # 	<string>/Users/wtraylor/logs/borgrun/borgmatic.out</string>
  # 	<key>StartCalendarInterval</key>
  # 	<dict>
  # 		<key>Hour</key>
  # 		<integer>3</integer>
  # 		<key>Minute</key>
  # 		<integer>0</integer>
  # 	</dict>
}

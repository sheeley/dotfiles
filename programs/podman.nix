{
  config,
  pkgs,
  lib,
  user,
  ...
}: let
in {
  environment.pathsToLink = ["/share/qemu"];

  home-manager.users.${user}.home = {
    packages = with pkgs; [
      podman
      podman-compose

      # for some reason this isn't included as a dependency of podman, and they have a note to not because it would break podman?
      qemu
    ];

    # config.lib.file.mkOutOfStoreSymlink
    # file.".config/hassio/etc/localtime".source = /var/db/timezone/zoneinfo/America/Los_Angeles;

    shellAliases = {
      docker = "podman";
    };
  };
}

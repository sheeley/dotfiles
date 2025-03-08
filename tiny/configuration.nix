{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../nixos-common.nix
    ../programs/nix-cache.nix
    # TODO: ./coredns.nix # https://github.com/NixOS/nixpkgs/pull/359426
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "tiny"; # Define your hostname.
  system.stateVersion = "24.05"; # Did you read the comment?

  networking.firewall.allowedUDPPorts = [53];
}

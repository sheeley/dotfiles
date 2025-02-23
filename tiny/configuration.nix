{
  config,
  lib,
  pkgs,
  ...
}: let
  corednsMDNS = pkgs.coredns.override {
    externalPlugins = [
      {
        name = "mdns";
        repo = "github.com/openshift/coredns-mdns";
        version = "master";
      }
    ];
    vendorHash = "sha256-CocHwNw6h6RJHkIarC7+ifHl7PmbodXwTeT99Jeg+xo=";
  };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../nixos-common.nix
    ../programs/nix-cache.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "tiny"; # Define your hostname.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  system.stateVersion = "24.05"; # Did you read the comment?

  networking.firewall.allowedUDPPorts = [53];
  services.coredns = {
    enable = true;
    package = corednsMDNS;
    config = ''
      local.aigee.org {
        mdns local.aigee.org
      }
    '';
  };
}

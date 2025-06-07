{
  lib,
  pkgs,
  private,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../shared/observability # Import shared observability
    ../nixos/common.nix
    ../programs/nix-cache.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "tiny";
  system.stateVersion = "24.05";

  # Observability configuration - Central server role
  services.observability = {
    enable = true;
    role = "server"; # Acts as central collection point
    hostName = "tiny";

    loki = {
      enable = true;
      port = 3100;
    };

    prometheus = {
      enable = true;
      port = 9001;
      scrapeInterval = "10s";
    };

    alloy = {
      enable = true;
    };
  };

  # Override UniFi exporter password from private
  services.prometheus.exporters.unpoller.controllers = lib.mkForce [
    {
      url = "https://172.20.1.1";
      user = "prom";
      pass = private.unpoller_pass;
    }
  ];

  # Container setup
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman
    dive
    podman-tui
  ];

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    hass-screenshot = {
      image = "lanrat/hass-screenshot";
      autoStart = true;
      ports = ["127.0.0.1:5000:5000"];
      environment = {
        TZ = "America/Los_Angeles";
        HA_BASE_URL = "https://hae.sheeley.house";
      };
    };
  };
}

{
  config,
  lib,
  pkgs,
  private,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./observability.nix
    ../nixos-common.nix
    ../programs/nix-cache.nix
    # ./coredns.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "tiny"; # Define your hostname.
  system.stateVersion = "24.05"; # Did you read the comment?

  # networking.firewall.allowedUDPPorts = [53];

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    podman
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    # docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
  ];
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    hass-screenshot = {
      image = "lanrat/hass-screenshot";
      autoStart = true;
      ports = ["127.0.0.1:5000:5000"];
      # memory: 1G
      # healthcheck:
      #   test: "wget --no-verbose --tries=1 --spider http://localhost:5000/ || exit 1"
      #   interval: 60s
      #   timeout: 5s
      #   retries: 3
      #   start_period: 60s
      environment = {
        TZ = "America/Los_Angeles";
        HA_BASE_URL = "https://hae.sheeley.house";
        HA_ACCESS_TOKEN = private.HA_ACCESS_TOKEN;
        LANGUAGE = "en";
        MQTT_SERVER = "hae.sheeley.house";
        REAL_TIME = true;
        RENDERING_DELAY = 2;
        COLOR_MODE = "GrayScale";
        # image 1
        HA_SCREENSHOT_URL = "/dashboard-inkplate/0?kiosk";
        RENDERING_SCREEN_HEIGHT = 825;
        RENDERING_SCREEN_WIDTH = 1200;
        GRAYSCALE_DEPTH = 3;
        # # image 2
        # HA_SCREENSHOT_URL_2 = "/lovelace-infra/hud2?kiosk";
        # RENDERING_SCREEN_HEIGHT_2 = 800;
        # RENDERING_SCREEN_WIDTH_2 = 600;
        # GRAYSCALE_DEPTH_2 = 4;
        # # image 3
        # HA_SCREENSHOT_URL_3 = "/lovelace-infra/hud3?kiosk";
        # RENDERING_SCREEN_HEIGHT_3 = 800;
        # RENDERING_SCREEN_WIDTH_3 = 600;
        # GRAYSCALE_DEPTH_3 = 4;
      };
    };
  };
}

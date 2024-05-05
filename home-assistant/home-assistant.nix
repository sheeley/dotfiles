{pkgs, ...}: let
in {
  networking.firewall.allowedUDPPorts = [
    # homekit
    5353
  ];

  networking.firewall.allowedTCPPorts = [
    8123
    # homekit
    21063
  ];
  # virtualisation.oci-containers = {
  #   backend = "podman";
  #   containers.homeassistant = {
  #     image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
  #     volumes = [
  #       (./ha-configuration + ":/config")
  #     ];
  #
  #     environment.TZ = "America/Los_Angeles";
  #     extraOptions = [
  #       "--network=host"
  #       # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
  #     ];
  #
  #     ports = [
  #       "8123:8123"
  #
  #       # homekit
  #       "5353:5353"
  #       "21063:21063"
  #     ];
  #   };
  # };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # from https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/home-assistant/component-packages.nix
      "default_config"
      "met"
      "esphome"

      # custom
      "androidtv_remote"
      "apple_tv"
      "anthemav"
      "backup"
      "bluetooth"
      "bluetooth_adapters"
      "bluetooth_le_tracker"
      "bluetooth_tracker"
      "cast"
      "elgato"
      "homekit"
      "homekit_controller"
      "ios"
      "ipp"
      # "lovelace"
      "mobile_app"
      "opower"
      "pge"
      "plex"
      "spotify"
      "tailscale"
      "unifi"
      "unifi_direct"
      "unifiprotect"
    ];

    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};

      logger = {
        default = "debug";
      };

      homeassistant = {
        customize = {};

        name = "Home";
        latitude = 37.5473015230886;
        longitude = -122.29248094625427;
        elevation = 0;

        # latitude = "!secret latitude";
        # longitude = "!secret longitude";
        # elevation = "!secret elevation";
        country = "US";

        unit_system = "imperial";
        time_zone = "America/Los_Angeles";
      };
    };

    customComponents = [
      # import
      # ./hyundai.nix
      # import
      # ./hatch.nix
    ];
  };
}

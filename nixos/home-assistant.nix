{pkgs, ...}: let
  buildPythonPackage = pkgs.python312Packages.buildPythonPackage;
  setuptools = pkgs.python312Packages.setuptools;
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
        default = "info";
      };

      homeassistant = {
        customize = {};
        name = "Home";

        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        country = "US";

        unit_system = "imperial";
        time_zone = "America/Los_Angeles";
      };
    };

    # customComponents = [
    #   (let
    #     aiohttp = pkgs.python312Packages.aiohttp;
    #     awscrt = pkgs.python312Packages.awscrt;
    #     awsiotsdk = buildPythonPackage rec {
    #       pname = "awsiotsdk";
    #       version = "1.21.0";
    #
    #       pyproject = true;
    #
    #       nativeBuildInputs = [setuptools];
    #       propagatedBuildInputs = [
    #         awscrt
    #       ];
    #
    #       src = pkgs.fetchPypi {
    #         inherit pname version;
    #         hash = "sha256-w+idl0zg+C8uftz6EFLYND1oAC2HtQr8RwyFpvOFSFg=";
    #       };
    #     };
    #
    #     hatch_rest_api = buildPythonPackage rec {
    #       pname = "hatch_rest_api";
    #       version = "1.21.0";
    #
    #       pyproject = true;
    #
    #       nativeBuildInputs = [setuptools];
    #       propagatedBuildInputs = [
    #         awsiotsdk # >=1.21.0
    #         aiohttp # >=3.8.1
    #       ];
    #
    #       src = pkgs.fetchPypi {
    #         inherit pname version;
    #         hash = "sha256-GUsy1TsK+KW9yhi/2TD8eGWmB0UF0Uau+msEVAee4k4=";
    #       };
    #     };
    #   in
    #     pkgs.buildHomeAssistantComponent {
    #       owner = "dahlb";
    #       domain = "ha_hatch";
    #       version = "1.17.1";
    #       src = pkgs.fetchFromGitHub {
    #         owner = "dahlb";
    #         repo = "ha_hatch";
    #         rev = "v1.17.1";
    #         hash = "sha256-YUBBSoPMe5bghsUJ2jpRHWvLQftkgWNaMuHqTZ5wZQg=";
    #       };
    #       propagatedBuildInputs = [
    #         hatch_rest_api # ==1.21.0"
    #       ];
    #     })

    # (pkgs.buildHomeAssistantComponent {
    #   owner = "Hyundai-Kia-Connect";
    #   domain = "kia_uvo";
    #   version = "2.24.2";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "Hyundai-Kia-Connect";
    #     repo = "kia_uvo";
    #     rev = "v2.24.2";
    #     hash = "sha256-i9P7Po6fqxbTsZMHw6YSBfQkIasF38y0Ru9kWj0RyEk=";
    #   };
    #
    #   propagatedBuildInputs = [
    #     "hyundai_kia_connect_api" # ==3.19.1"
    #   ];
    # })
    # ];
  };
}

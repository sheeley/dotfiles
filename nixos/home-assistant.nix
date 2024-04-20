{...}: {
  networking.firewall.allowedUDPPorts = [
    # homekit
    5353
  ];

  networking.firewall.allowedTCPPorts = [
    8123
    # homekit
    21063
  ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      volumes = [
        (./ha-configuration + ":/config")
      ];

      environment.TZ = "America/Los_Angeles";
      extraOptions = [
        "--network=host"
        # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
      ];

      ports = [
        "8123:8123"

        # homekit
        "5353:5353"
        "21063:21063"
      ];
    };
  };

  # services.home-assistant = {
  #   enable = true;
  #   extraComponents = [
  #     # Components required to complete the onboarding
  #     # "esphome"
  #     # "met"
  #     # "radio_browser"
  #   ];
  #   config = {
  #     # Includes dependencies for a basic setup
  #     # https://www.home-assistant.io/integrations/default_config/
  #     default_config = {};
  #
  #     logger = {
  #       default = "info";
  #     };
  #   };
  # };
}

{...}: {
  networking.firewall.allowedTCPPorts = [8123];
  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = ["home-assistant:/config"];
      environment.TZ = "America/Los_Angeles";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
        # "--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
      ];
    };
  };
}
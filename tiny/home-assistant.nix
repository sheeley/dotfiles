{
  # config,
  pkgs,
  # lib,
  nixvirt,
  # private,
  # stdenv,
  ...
}: let
  # Define the URL and SHA for the latest Home Assistant OS QCOW2.xz compressed release
  haCompressedImageUrl = "https://github.com/home-assistant/operating-system/releases/download/13.2/haos_generic-aarch64-13.2.qcow2.xz";
  haImageSha256 = ""; # Replace this with the SHA-256 hash

  homeAssistantImage = pkgs.fetchzip {
    url = haCompressedImageUrl;
    hash = haImageSha256;
    nativeBuildInputs = [pkgs.xz];
  };
  # unpackPhase = ":";
  # unpackPhase = ''
  #   echo $out
  #   ls $out
  #   xz --decompress "$src"
  #   ls
  #     mv ./*.qcow2 $out
  # '';
  # };
  # Fetch, verify, and decompress the QCOW2 image
  # homeAssistantImage = pkgs.runCommand "home-assistant-image" {} ''
  #   # Download the compressed image
  #   curl -L ${haCompressedImageUrl} -o hassos_ova.qcow2.xz
  #
  #   # Verify the SHA-256 hash of the downloaded file
  #   # echo "${haImageSha256}  hassos_ova.qcow2.xz" | sha256sum -c -
  #
  #   # Decompress the image
  #   xz -d hassos_ova.qcow2.xz
  #
  #   # Move to the output path expected by Nix
  #   mv hassos_ova.qcow2 $out
  # '';
  # homeAssistantImage = pkgs.fetchurl {
  #   url = haCompressedImageUrl;
  #   hash = "";
  #   nativeBuildInputs = [pkgs.xz];
  #   postFetch = ''
  #     # Decompress the image
  #     ls
  #     echo $src
  #     xz --decompress *.xz
  #
  #     # Move to the output path expected by Nix
  #     mv ./*.qcow2 $out
  #   '';
  # };
  # homeAssistantImage = stdenv.mkDerivation {
  #   name = "ha.qcow2";
  #   src = pkgs.fetchurl {
  #     url = haCompressedImageUrl;
  #     hash = haImageSha256;
  #   };
  #   unpackPhase = ":";
  #   nativeBuildInputs = [pkgs.xz];
  #   installPhase = ''
  #     xz --decompress "$src"
  #     ls
  #       mv ./*.qcow2 $out
  #   '';
  # };
in {
  networking.firewall.allowedTCPPorts = [
    5901
  ];
  # imports = [nixvirt.nixosModules.default];
  # Enable the libvirt service for virtual machine management
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirt.enable = true;

  # Define a connection for managing VMs
  virtualisation.libvirt.connections."qemu:///system".domains = [
    {
      # Define the Home Assistant VM using the nixvirt Linux template
      definition = nixvirt.lib.domain.writeXML (nixvirt.lib.domain.templates.linux {
        name = "homeassistant";
        uuid = "40616990-a08e-4eff-890c-5206e1770ab2";

        memory = {
          count = 2048;
          unit = "MiB";
        };

        # Path to the QCOW2 disk image for Home Assistant
        storage_vol = {
          pool = "default";
          volume = "${homeAssistantImage}";
        };

        # TODO: Add a second disk pointing to the shared directory
        # TODO: need to `sudo mount /dev/vdb /path/to/mountpoint`
        # extra_disks = [
        #   {
        #     target = "vdb"; # Target device name in VM (e.g., /dev/vdb)
        #     source = "/mnt/Stash"; # Path to the shared directory on the host
        #     driver = {type = "raw";}; # RAW file type for directories
        #     format = "host_device"; # Host device format
        #     readonly = false; # Make it writable
        #   }
        # ];

        # Network settings (default to VirtIO for better performance)
        # virtio_net = true;

        # Video and VNC settings for remote graphical access
        # video = {
        #   type = "vga";
        # };

        # graphics = {
        #   type = "vnc";
        #   port = 5901;
        #   listen = "0.0.0.0"; # TODO: Bind to all interfaces (optional, secure accordingly)
        #   password = "your-secure-password"; # TODO: VNC access password (for security)
        # };
      });

      # Set the VM to start automatically with the host
      active = true;
    }
  ];

  # Optionally, define storage pools, networks, or additional configurations as needed.
}

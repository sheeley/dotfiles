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
  haCompressedImageUrl = "https://github.com/home-assistant/operating-system/releases/download/13.2/haos_generic-x86-64-13.2.img.xz";
  haImageSha256 = "sha256-0+tgAma6VbUfxclDGWlKfCTiBTsI2vDAY2fOdjXmNMQ=";

  homeAssistantImage = pkgs.fetchurl {
    name = "ha.img";
    url = haCompressedImageUrl;
    hash = haImageSha256;
    nativeBuildInputs = [pkgs.xz];
    downloadToTemp = true;
    postFetch = ''
      mv $downloadedFile $downloadedFile.xz
      ${pkgs.xz}/bin/xz --decompress $downloadedFile.xz
      mv $downloadedFile $out
    '';
  };
in {
  # TODO:
  # read
  # https://myme.no/posts/2021-11-25-nixos-home-assistant.html
  # and
  # https://github.com/myme/dotfiles/blob/4cb6fc69b27e6f7154336336f6e2a03b9ec5ec03/machines/nuckie/default.nix#L17
  networking.firewall.allowedTCPPorts = [
    5901
  ];
  # this only needs to be turned on manually if using the home-manager module
  # virtualisation.libvirtd.enable = true;

  virtualisation.libvirt = {
    # Enable the libvirt service for virtual machine management
    enable = true;
    connections."qemu:///system" = {
      pools = [
        {
          active = true;
          definition = nixvirt.lib.pool.writeXML {
            name = "default";
            uuid = "650c5bbb-eebd-4cea-8a2f-36e1a75a8683";
            type = "dir";
            target = {path = "/mnt/Stash/home-assistant/root";};
          };
        }
      ];

      domains = [
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
            extra_disks = [
              {
                target = "vdb"; # Target device name in VM (e.g., /dev/vdb)
                source = "/mnt/Stash/home-assistant/extra"; # Path to the shared directory on the host
                driver = {type = "raw";}; # RAW file type for directories
                format = "host_device"; # Host device format
                readonly = false; # Make it writable
              }
            ];

            # Network settings (default to VirtIO for better performance)
            virtio_net = true;

            # Video and VNC settings for remote graphical access
            video = {
              type = "vga";
            };

            graphics = {
              type = "vnc";
              port = 5901;
              listen = "0.0.0.0"; # TODO: Bind to all interfaces (optional, secure accordingly)
              password = "your-secure-password"; # TODO: VNC access password (for security)
            };
          });

          # Set the VM to start automatically with the host
          active = true;
        }
      ];
    };
  };

  # Optionally, define storage pools, networks, or additional configurations as needed.
}

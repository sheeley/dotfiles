# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  # config,
  # pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../home-assistant/home-assistant.nix
    ../programs/podman.nix
    ../programs/plex.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  # systemd.network.wait-online.enable = false;
  # boot.initrd.systemd.network.wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheeley = {
    isNormalUser = true;
    description = "Johnny Sheeley";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.mosh.enable = true;

  # environment.systemPackages = with pkgs; [];
}
# let
# When using easyCerts=true the IP Address must resolve to the master on creation.
# So use simply 127.0.0.1 in that case. Otherwise you will have errors like this https://github.com/NixOS/nixpkgs/issues/59364
# kubeMasterIP = "127.0.0.1";
# kubeMasterIP = "192.168.1.17";
# kubeMasterHostname = "api.kube";
# kubeMasterAPIServerPort = 6443;
# in
# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [6443 8080 8123];
# networking.firewall.allowedUDPPorts = [ ... ];
# k8s stuff
# networking.extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
# services.kubernetes = {
#   roles = ["master" "node"];
#   masterAddress = kubeMasterHostname;
#   apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
#   easyCerts = true;
#   apiserver = {
#     securePort = kubeMasterAPIServerPort;
#     advertiseAddress = kubeMasterIP;
#   };
#
#   # use coredns
#   addons.dns.enable = true;
#
#   # needed if you use swap
#   kubelet.extraOpts = "--fail-swap-on=false";
# };


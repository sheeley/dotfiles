{...}: {
  users.users.sheeley = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+lLS1vAe3MEUi9XXo9ZZwGZ+cpI/lafP8ytN+o2u78"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqtaVNjGmJFYZaGA1/tVVk+ZNOqkMLe3AIkjexe7yW3"
    ];
  };

  time.timeZone = "America/Los_Angeles";
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

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
      workstation = true;
    };
  };
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # store /tmp in memory
  boot.tmp.useTmpfs = true;
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };

  # ssd maintenance
  services.fstrim.enable = true;

  # fast dbus
  # services.dbus.implementation = "broker";
}

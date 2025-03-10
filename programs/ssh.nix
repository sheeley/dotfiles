{...}: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/control/%r@%h:%p";
    controlPersist = "10m";
    extraConfig = "
IdentityFile ~/.ssh/id_ed25519
AddKeysToAgent yes
ConnectTimeout = 3

Host homebase
  HostName homebase.local
  User sheeley
  # RequestTTY force
  # RemoteCommand zellij attach --create

Host proxmox
  HostName proxmox.aigee.org
  User root

Host pbs
  HostName pbs.aigee.org
  User root
      ";
  };
}

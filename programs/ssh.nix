{...}: {
  # services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "auto";
    controlPath = "~/.ssh/control/%r@%h:%p";
    controlPersist = "10m";
    extraConfig = "
IdentityFile ~/.ssh/id_ed25519
AddKeysToAgent yes
ConnectTimeout = 3
User sheeley

Host homebase
  HostName homebase.sheeley.house
  # RequestTTY force
  # RemoteCommand zellij attach --create

Host proxmox
  HostName proxmox.sheeley.house

Host tiny
  HostName tiny.sheeley.house
      ";
  };
}

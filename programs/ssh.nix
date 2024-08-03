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
      ";
  };
}

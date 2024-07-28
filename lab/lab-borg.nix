{
  private,
  user,
  ...
}: {
  services.borgbackup.jobs.homelab = {
    paths = [
      (builtins.toString /mnt/Media)
    ];
    exclude = [
      "lost+found"
    ];
    encryption = {
      mode = "repokey";
      passphrase = private.borgSecret;
    };
    user = user;
    repo = "ssh://${private.borgUser}@${private.borgUser}.repo.borgbase.com/./repo";
    compression = "auto,zstd";
    startAt = "daily";
  };
}

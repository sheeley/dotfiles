{
  lib,
  pkgs,
  user,
  private,
  ...
}: let
  prefix =
    if pkgs.system == "aarch64-darwin"
    then "Users"
    else "home";
  homeDir = "/${prefix}/${user}";
  # keyFiles = builtins.attrNames (builtins.readDir ./authorized_keys);
  # keyContents = map (v: builtins.readFile (lib.path.append ./authorized_keys "${v}")) keyFiles;
  # keysJoined = builtins.concatStringsSep "\n" keyContents;
in {
  imports = (lib.optionals (lib.hasAttr "personal" private && private.personal)) [
    # personal only
  ];

  users.users.${user} = {
    shell = pkgs.fish;
    name = user;
    home = homeDir;
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    zsh
  ];
}

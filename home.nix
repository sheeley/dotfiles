{
  config,
  pkgs,
  # lib,
  user,
  inputs,
  private,
  ...
}: let
  isMac = pkgs.system == "aarch64-darwin";
  prefix =
    if isMac
    then "Users"
    else "home";
  homeDir = "/${prefix}/${user}";
in {
  home-manager = {
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      private = private;
    };
  };

  home-manager.users.${user} = {lib, ...}: {
    home.homeDirectory = homeDir;
    imports = [
      (
        import
        ./home-manager.nix
        {
          inherit config lib user inputs private pkgs isMac;
        }
      )
    ];
  };
}

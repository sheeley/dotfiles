{
  config,
  pkgs,
  # lib,
  user,
  inputs,
  private,
  ...
}: let
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
    imports = [
      (
        import
        ./home-manager.nix
        {
          inherit config lib user inputs private pkgs;
        }
      )
    ];
  };
}

{
  # config,
  pkgs,
  # lib,
  user,
  inputs,
  private,
  isMac ? true,
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
  # verbose = true;

  home-manager.users.${user} = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [./home.nix {specialArgs = {inherit inputs;};}];
  };
  # home-manager.users.${user} = import ./home.nix;
}

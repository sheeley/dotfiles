{ darwin, user, legacyPackages, home-manager, nixpkgs, ... }:
{
    darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyPackages.aarch64-darwin;
      modules = [
        home-manager.darwinModules.home-manager
        ./environment.nix
        ./homebrew.nix
        ./home.nix
        ./system.nix
      ];
      inputs = { inherit nixpkgs home-manager darwin; user = "sheeley"; };
    };
}
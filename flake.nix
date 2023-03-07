{
  description = "My first nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin }@inputs: rec {
    legacyPackages = nixpkgs.lib.genAttrs [ "aarch64-darwin" ] (system:
      import inputs.nixpkgs {
        inherit system;
        # NOTE: Using `nixpkgs.config` in your NixOS config won't work
        # Instead, you should set nixpkgs configs here
        # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)

        config.allowUnfree = true;
      }
    );

    # you can have multiple darwinConfigurations per flake, one per hostname
    darwinConfigurations."jmba" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyPackages.aarch64-darwin;
      modules = [
        home-manager.darwinModules.home-manager
        ./environment.nix
        ./homebrew.nix
        ./home.nix
        ./system.nix
      ];
    };
  };
}

{
  description = "System setup";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-private = {
      # git+file://
      url = "path:/Users/johnnysheeley/.nix-private";
      flake = false;
    };

    # flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    nixvim,
    nix-private,
  } @ inputs: let
    legacyPackages = nixpkgs.lib.genAttrs ["aarch64-darwin"] (
      system:
        import inputs.nixpkgs {
          inherit system;
          # NOTE: Using `nixpkgs.config` in your NixOS config won't work
          # Instead, you should set nixpkgs configs here
          # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)

          config.allowUnfree = true;
        }
    );
    # private = import ./.nix-private/private.nix {};
    private = "${nix-private}/private.nix";
  in {
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

      specialArgs = {
        inherit inputs;
        user = "sheeley";
      };
    };

    darwinConfigurations."Sheeley-MBP" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyPackages.aarch64-darwin;
      modules = [
        home-manager.darwinModules.home-manager
        ./environment.nix
        ./homebrew.nix
        ./home.nix
        ./system.nix
      ];
      # extraModules = [private];

      specialArgs = {
        inherit inputs private nix-private;
        user = "johnnysheeley";
        # private = private;
      };
    };
  };
}

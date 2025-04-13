{
  description = "System setup";
  inputs = {
    # unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # stable
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    nixvim,
    flake-utils,
  } @ inputs: let
    legacyDarwinPackages = nixpkgs.lib.genAttrs ["aarch64-darwin"] (
      system:
        import inputs.nixpkgs {
          inherit system;
          # NOTE: Using `nixpkgs.config` in your NixOS config won't work
          # Instead, you should set nixpkgs configs here
          # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)

          config.allowUnfree = true;
        }
    );
    legacyNixPackages = nixpkgs.lib.genAttrs ["x86_64-linux"] (
      system:
        import inputs.nixpkgs {
          inherit system;
          # NOTE: Using `nixpkgs.config` in your NixOS config won't work
          # Instead, you should set nixpkgs configs here
          # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)

          config.allowUnfree = true;
        }
    );
    sharedModules = [
      ./environment.nix
      ./home.nix
      ./system.nix
    ];
    sharedDarwinModules =
      [
        home-manager.darwinModules.home-manager
        ./darwin.nix
        ./homebrew.nix
      ]
      ++ sharedModules;
    private =
      if builtins.currentSystem == "aarch64-darwin"
      then legacyDarwinPackages.aarch64-darwin.callPackage ~/.nix-private/private.nix {}
      else legacyDarwinPackages.aarch64-darwin.callPackage /home/sheeley/.nix-private/private.nix {};
  in {
    darwinConfigurations."jmba" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyDarwinPackages.aarch64-darwin;
      modules =
        sharedDarwinModules
        ++ [
          ./personal.nix
        ];

      specialArgs = {
        inherit inputs;
        user = "sheeley";
        private = private;
      };
    };

    darwinConfigurations."homebase" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyDarwinPackages.aarch64-darwin;
      modules =
        sharedDarwinModules
        ++ [
          ./personal.nix
          ./homebase/homebase.nix
          ./programs/podman.nix
        ];

      specialArgs = {
        inherit inputs;
        user = "sheeley";
        private = private;
        storagePath = "/Volumes/Slash";
      };
    };

    darwinConfigurations."Sheeley-MBP" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyDarwinPackages.aarch64-darwin;
      modules = sharedDarwinModules;

      specialArgs = {
        inherit inputs;
        user = "johnnysheeley";
        private = private;
      };
    };

    homeConfigurations."sheeley" = home-manager.lib.homeManagerConfiguration {
      system = "x86_64-linux";
      pkgs = legacyNixPackages.x86_64-linux;
      modules =
        [
          ./environment.nix
          ./home.nix
        ]
        ++ sharedModules;

      specialArgs = {
        inherit inputs;
        user = "sheeley";
        private = private;
      };
    };

    nixosConfigurations."tiny" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      pkgs = legacyNixPackages.x86_64-linux;
      modules =
        [
          home-manager.nixosModules.home-manager
          ./tiny/tiny.nix
        ]
        ++ sharedModules;

      specialArgs = {
        inherit inputs;
        user = "sheeley";
        private = private;
      };
    };

    # This creates a REPL I guess, `nix run #repl`
    apps.repl = flake-utils.lib.mkApp {
      drv = legacyDarwinPackages.aarch64-darwin.writeShellScriptBin "repl" ''
        confnix=$(mktemp)
        echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
        trap "rm $confnix" EXIT
        nix repl $confnix
      '';
    };
  };
}

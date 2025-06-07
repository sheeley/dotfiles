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
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-diff = {
      url = "github:pedorich-n/home-manager-diff";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    home-manager-diff,
    darwin,
    nixvim,
    flake-utils,
  } @ inputs: let
    inherit (self) outputs;
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
      ./home-manager.nix
      ./system.nix
    ];
    sharedDarwinModules =
      [
        home-manager.darwinModules.home-manager
        ./darwin/general.nix
        ./homebrew.nix
        ./darwin/hm.nix
      ]
      ++ sharedModules;
    private = import ./private.nix;
  in {
    darwinConfigurations."jmba" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyDarwinPackages.aarch64-darwin;
      modules =
        sharedDarwinModules
        ++ [
          ./darwin/personal.nix
        ];

      specialArgs = {
        inherit inputs;
        user = "sheeley";
        inherit private;
      };
    };

    darwinConfigurations."homebase" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyDarwinPackages.aarch64-darwin;
      modules =
        sharedDarwinModules
        ++ [
          ./darwin/personal.nix
          ./homebase/homebase.nix
          ./programs/podman.nix
        ];

      specialArgs = {
        inherit inputs;
        user = "sheeley";
        inherit private;
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
        inherit private;
      };
    };

    darwinConfigurations."stud" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = legacyDarwinPackages.aarch64-darwin;
      modules =
        sharedDarwinModules
        ++ [
          ./darwin/personal.nix
        ];

      specialArgs = {
        inherit inputs;
        user = "sheeley";
        inherit private;
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
        inherit private;
        isMac = false;
      };
    };

    # just one of these because home manager uses username.
    # to customize, create a host-specific script like proxmox/setup
    homeConfigurations."sheeley" = home-manager.lib.homeManagerConfiguration {
      pkgs = legacyNixPackages.x86_64-linux;
      modules = [
        home-manager-diff.hmModules.default
        {
          programs.hmd = {
            enable = true;
            runOnSwitch = true; # enabled by default
          };
          services.home-manager.autoExpire.enable = true;
        }
        ./home.nix
      ];

      extraSpecialArgs = {
        inherit inputs outputs;
        user = "sheeley";
        inherit private;
        isMac = false;
        inherit nixvim;
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

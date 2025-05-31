{
  description = "A faster, persistent implementation of `direnv`'s `use_nix`, to replace the built-in one.";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          system = "${system}";
          config.allowUnfree = true;
        };
        buildInputs = with pkgs; [
          awscli2
          opentofu
          terraform
        ];
      in {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;

          shellHook = builtins.concatStringsSep "\n" (
            map (pkg: ''print-flake-packages "${pkg}"'')
            buildInputs
          );
        };
      }
    );
}

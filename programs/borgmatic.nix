{ pkgs, ... }:
let
  private = pkgs.callPackage ~/.nix-private/private.nix { };
in
{
  programs.borgmatic = {
    # TODO: swap borgmatic to home-manager
    enable = false;
  };
  home.file.".config/borgmatic/config.yaml".source = pkgs.substituteAll {
    name = "config.yaml";
    src = ../files/borgmatic/config.yaml;
    secret = "${private.borgSecret}";
    repo = "${private.borgRepo}";
  };
}

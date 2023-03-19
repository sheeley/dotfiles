{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      b4dm4n.vscode-nixpkgs-fmt
      esbenp.prettier-vscode
      hashicorp.terraform
      jnoortheen.nix-ide
      timonwong.shellcheck
      bbenoist.nix
    ];
    userSettings = {
      "editor.minimap.enabled" = false;
      "editor.formatOnSave" = true;
    };
  };
}

{pkgs, ...}: {
  programs.vscode = {
    enable = false;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    # package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      christian-kohler.path-intellisense
      esbenp.prettier-vscode
      hashicorp.terraform
      jnoortheen.nix-ide
      kamadorueda.alejandra
      timonwong.shellcheck
    ];

    userSettings = {
      "editor.minimap.enabled" = false;
      "editor.formatOnSave" = true;
      "extensions.ignoreRecommendations" = true;
    };
  };
}

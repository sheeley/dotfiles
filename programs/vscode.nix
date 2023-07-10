{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium;

    extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode
      hashicorp.terraform
      jnoortheen.nix-ide
      timonwong.shellcheck
      bbenoist.nix
      kamadorueda.alejandra
    ];

    userSettings = {
      "editor.minimap.enabled" = false;
      "editor.formatOnSave" = true;
      "extensions.ignoreRecommendations" = true;
    };
  };
}

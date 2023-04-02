{pkgs, ...}: {
  programs.vscode = {
    enable = true;

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

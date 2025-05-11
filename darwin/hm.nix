{user, ...}: {
  home-manager.users.${user} = {lib, ...}: {
    home.sessionVariables.SSH_ASKPASS = "/opt/homebrew/bin/touch2sudo";

    imports = [
      # ./programs/ghostty.nix
      # ../programs/vscode.nix
      ./home-darwin-defaults.nix
    ];
  };
}

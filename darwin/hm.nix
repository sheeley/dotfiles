{user, ...}: {
  home-manager.users.${user} = {lib, ...}: {
    imports = [
      # ./programs/ghostty.nix
      ../programs/vscode.nix
      ./home-darwin-defaults.nix
    ];
  };
}

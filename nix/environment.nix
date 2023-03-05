{ pkgs, ... }:
{
  services.nix-daemon.enable = true;

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.shells = [ pkgs.fish ];
  environment.systemPath = [
    "$HOME/bin"
    "$HOME/projects/sheeley/infrastructure/bin"
    "$HOME/projects/sheeley/infrastructure/scripts"
    "/run/current-system/sw/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "/usr/local/sbin"
    "/Applications/Xcode.app/Contents/Developer/usr/bin"
    "/sbin"
    "/usr/sbin"
    "/bin"
    "/usr/bin"
  ];
  environment.variables = { };
  fonts.fonts = [
    pkgs.nerdfonts
  ];
}

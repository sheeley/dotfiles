{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    settings = {
      copy_command = if pkgs.stdenv.isDarwin then "pbcopy" else "copyq copy -";
      # default_mode = "locked";
      show_startup_tips = false;
      session_serialization = false;
      # default_layout = "compact";
      keybinds = {
        locked = {
          bind = {
            "Ctrl m" = {
              SwitchToMode = "Move";
            };
          };
        };
      };
    };
  };
}

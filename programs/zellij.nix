{pkgs, ...}: {
  programs.zellij = {
    enable = true;

    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;

    settings = {
      show_startup_tips = false;
      session_serialization = false;
      # default_layout = "compact";
      keybinds = {
        locked = {
          # bind = {
          #   "Ctrl m" = {
          #     SwitchToMode = "Move";
          #   };
          # };
        };
        normal = {
          unbind = "Ctrl h";
        };
      };
    };
  };
}

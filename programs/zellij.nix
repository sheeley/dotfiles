{...}: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    settings = {
      copy_command = "pbcopy";
      default_mode = "locked";
      show_startup_tips = false;
      # default_layout = "compact";
    };
  };
}

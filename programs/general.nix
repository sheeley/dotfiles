{pkgs, ...}: {
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.home-manager.enable = true;

  programs.broot = {
    enable = true;

    enableFishIntegration = true;
    # enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.fzf = {
    enable = true;

    enableFishIntegration = true;
    # enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # enableFishIntegration is unecessary, works by default
    enableNushellIntegration = true;
    enableZshIntegration = true;

    config = {
      warn_timeout = 0;
    };
  };
}

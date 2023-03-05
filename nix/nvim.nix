{ pkgs, ... }:
{
  environment.variables.EDITOR = "nvim";

  home-manager.users.sheeley.programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
    '';
    viAlias = true;
    vimAlias = true;
  };
}

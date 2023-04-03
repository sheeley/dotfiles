{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;

    #     function mkcd
    #   mkdir $argv
    #   cd $argv
    # end

    # function clonecd
    #   git clone $argv
    #   cd (basename $argv .git)
    # end
  };
}

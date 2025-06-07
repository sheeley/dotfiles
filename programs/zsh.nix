_: {
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };

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

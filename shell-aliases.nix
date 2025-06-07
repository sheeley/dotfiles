_: {
  home = {
    shellAliases = {
      amend = "git commit --amend --no-edit";
      cddot = "cd ~/dotfiles";
      cdgo = "cd $GOPATH/src";
      cdicloud = "cd $ICLOUD_DIR";
      cdinfra = "cd $PRIVATE_TOOLS_DIR";
      cdnotes = "cd $NOTES_DIR";
      # cdproj = "cd $HOME/projects/sheeley/$1* || ";
      cdproj = "cd $HOME/projects/sheeley/";
      cdscratch = "cd ~/scratch";
      cdtools = "cd $TOOLS_DIR";
      cdwork = "cd ~/work";
      cdworknotes = "cd $WORK_NOTES_DIR";
      clone = "git clone";
      l = "a";
      la = "ls -la";
      lc = "light_control";
      u = "./update";
      va = "vim ./apply";
      vas = "vim ./apply_sudo";
      vdot = "vim ~/dotfiles";
      vprivate = "vim ~/dotfiles/private.nix";
      vv = "vim ~/dotfiles/bin/v";
    };
  };
}

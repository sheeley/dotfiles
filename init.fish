set fish_greeting # Disable greeting
set -U fish_escape_delay_ms 300
function fish_user_key_bindings
    # bind \c. 'history-token-search-backward'
    bind \e. 'history-token-search-backward'
end

function fish_title
  if test $_ != "fish"
    echo $_ ' '
  end
  fish_prompt_pwd_dir_length=3 prompt_pwd
end

function cdcz
  cd (chezmoi source-path)
end

function cdct
  cd (chezmoi source-path)/tools
end

function cdgo
  cd $GOPATH/src
end

function cdproj
  cd $HOME/projects/sheeley
end

function cdinfra
  cd $PRIVATE_TOOLS_DIR
end

function cdtools
  cd $TOOLS_DIR
end

function cdnotes
  cd $NOTES_DIR
end

function cdicloud
  cd ~/Library/Mobile\ Documents/com~apple~CloudDocs
end

function editinfra
  $EDITOR $PRIVATE_TOOLS_DIR
end

function edittools
  $EDITOR $TOOLS_DIR
end

function mkcd
  mkdir $argv
  cd $argv
end

function clone
  git clone $argv
end

function clonecd
  git clone $argv
  cd (basename $argv .git)
end

function reload
  source "$HOME/.config/fish/config.fish"
end

test -e {$HOME}/.iterm2_shell_integration.fish
and source {$HOME}/.iterm2_shell_integration.fish
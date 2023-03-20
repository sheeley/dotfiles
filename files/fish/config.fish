set fish_greeting # Disable greeting
set -U fish_escape_delay_ms 300

fish_add_path -P "$HOME/bin" \
  "$HOME/projects/sheeley/infrastructure/bin" \
  "$HOME/projects/sheeley/infrastructure/scripts" \
  "$HOME/go/bin" \
  "$HOME/.cargo/bin" \
  "/etc/profiles/per-user/default/bin/" \
  "/opt/homebrew/bin" \
  "/Applications/Xcode.app/Contents/Developer/usr/bin" \
  /sbin /usr/sbin /bin /usr/bin

function fish_title
  if test $_ != "fish"
    echo $_ ' '
  end
  fish_prompt_pwd_dir_length=3 prompt_pwd
end

function mkcd
  mkdir $argv
  cd $argv
end

function clonecd
  git clone $argv
  cd (basename $argv .git)
end

test -e {$HOME}/.iterm2_shell_integration.fish
and source {$HOME}/.iterm2_shell_integration.fish

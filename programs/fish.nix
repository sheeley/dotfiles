{
  pkgs,
  lib,
  ...
}: {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
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

      test -e {$HOME}/.iterm2_shell_integration.fish
      and source {$HOME}/.iterm2_shell_integration.fish

      if   not set -q ZELLIJ && test -n "$SSH_CONNECTION"
        if test "$ZELLIJ_AUTO_ATTACH" = "true"
          zellij attach -c
        else
          zellij
        end

        if test "$ZELLIJ_AUTO_EXIT" = "true"
          kill $fish_pid
        end
      end
    '';

    loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";

    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];

    functions = {
      __fish_describe_command = {
        body = "";
        onEvent = "__fish_describe_command";
      };

      fish_prompt = {
        body = builtins.readFile ../files/fish/fish_prompt.fish;
      };

      fish_title = {
        body = ''
          if test $_ != "fish"
          echo $_ ' '
          end
          fish_prompt_pwd_dir_length=3 prompt_pwd
        '';
      };

      mkcd = {
        body = ''
          mkdir $argv
          cd $argv
        '';
      };

      clonecd = {
        body = ''
          git clone $argv
          cd (basename $argv .git)
        '';
      };
    };
  };
}

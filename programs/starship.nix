{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$time | "
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "\${custom.git_status_simplified}"
        "$jobs"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      git_branch = {
        format = "[$symbol$branch]($style) ";
        style = "";
      };

      aws = {
        format = "[$symbol($profile )(\($region\) )]($style)";
      };

      time = {
        disabled = false;
        style = "bold";
        format = "[$time]($style) ";
      };

      cmd_duration = {
        format = ": [$duration]($style)";
        min_time = 100;
        show_milliseconds = true;
        style = "";
      };

      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };

      directory = {
        truncation_length = 5;
        truncate_to_repo = true;
      };


      custom = {
        git_status_simplified = {
          when = "test - n \"$(git status --porcelain)\"";
          symbol = "●";
          style = "yellow bold";
          format = "[ $symbol ] ($style)";
          shell = [ "bash" ];
        };
      };
    };
  };
}

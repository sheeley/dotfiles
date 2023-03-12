{ ... }:
{
  programs.helix = {
    enable = true;

    settings = {
      editor = {
        shell = [ "fish" ];
        cursorline = true;
      };

      "keys.normal" = {
        "g" = {
          "c" = {
            "c" = "toggle_comments";
          };
        };
        # "Ctrl-/" = "toggle_comments"
      };

      "keys.insert" = {
        ";" = {
          ";" = "normal_mode";
        };
      };
    };
  };
}

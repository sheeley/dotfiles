{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      window-inherit-working-directory = true;
      confirm-close-surface = false;
      clipboard-read = "allow";
      clipboard-write = "allow";
      copy-on-select = true;
      window-save-state = "always";
      window-theme = "system";
      theme = "Builtin Pastel Dark";
      background = "#000000";
      foreground = "#bbbbbb";
      selection-background = "#363983";
      selection-foreground = "#f2f2f2";
      cursor-color = "#ffa560";
      palette = [
        "0=#4f4f4f"
        "1=#ff6c60"
        "2=#a8ff60"
        "3=#ffffb6"
        "4=#96cbfe"
        "5=#ff73fd"
        "6=#c6c5fe"
        "7=#eeeeee"
        "8=#7c7c7c"
        "9=#ffb6b0"
        "10=#ceffac"
        "11=#ffffcc"
        "12=#b5dcff"
        "13=#ff9cfe"
        "14=#dfdffe"
        "15=#ffffff"
      ];
      font-family = "FiraCode Nerd Font Mono";
      keybind = [
        "super+p=text::Telescope find_files\n"
        "super+shift+p=text::Telescope commands\n"
      ];
    };
  };
}

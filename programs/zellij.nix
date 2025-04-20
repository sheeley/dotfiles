{...}: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    settings = {
      copy_command = "pbcopy";
      show_startup_tips = "false";
      # default_layout = "compact";
    };
    #       keybinds {
    #     // keybinds are divided into modes
    #     normal {
    #         // bind instructions can include one or more keys (both keys will be bound separately)
    #         // bind keys can include one or more actions (all actions will be performed with no sequential guarantees)
    #         bind "Ctrl g" { SwitchToMode "locked"; }
    #         bind "Ctrl p" { SwitchToMode "pane"; }
    #         bind "Alt n" { NewPane; }
    #         bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
    #     }
    #     pane {
    #         bind "h" "Left" { MoveFocus "Left"; }
    #         bind "l" "Right" { MoveFocus "Right"; }
    #         bind "j" "Down" { MoveFocus "Down"; }
    #         bind "k" "Up" { MoveFocus "Up"; }
    #         bind "p" { SwitchFocus; }
    #     }
    #     locked {
    #         bind "Ctrl g" { SwitchToMode "normal"; }
    #     }
    # }
  };
}

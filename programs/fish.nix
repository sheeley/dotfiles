{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ../files/init.fish;
    plugins = with pkgs; [
      { name = "foreign-env"; src = fishPlugins.foreign-env.src; }
      { name = "done"; src = fishPlugins.done.src; }
    ];

    functions = {
      __fish_describe_command_handler = {
        body = "";
        onEvent = "__fish_describe_command";
      };
    };
  };
}

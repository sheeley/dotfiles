{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ../files/fish/config.fish;

    plugins = with pkgs; [
      { name = "foreign-env"; src = fishPlugins.foreign-env.src; }
      { name = "done"; src = fishPlugins.done.src; }
    ];

    functions = {
      __fish_describe_command = {
        body = "";
        onEvent = "__fish_describe_command";
      };

      fish_prompt = {
        body = builtins.readFile ../files/fish/fish_prompt.fish;
      };
    };
  };
}

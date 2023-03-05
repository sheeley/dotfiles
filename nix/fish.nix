{ pkgs, ... }:
{
  programs.fish.enable = true;
  users.users.sheeley.shell = pkgs.fish;
  home-manager.users.sheeley.programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./init.fish;
    plugins = [
      #     # Enable a plugin (here grc for colorized command output) from nixpkgs
      #     { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      #     # Manually packaging and enable a plugin
      #     {
      #       name = "z";
      #       src = pkgs.fetchFromGitHub {
      #         owner = "jethrokuan";
      #         repo = "z";
      #         rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
      #         sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      #       };
      #     }
    ];
  };
}


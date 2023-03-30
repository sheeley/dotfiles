{
  pkgs,
  private,
  ...
}: let
in {
  programs.nushell = {
    enable = true;
    configFile.text = ''
      let-env config = {
          show_banner: false
      }
    '';
  };
}

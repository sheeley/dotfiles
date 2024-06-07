{
  # pkgs,
  # private,
  ...
}:
# let
# in
{
  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.show_banner = false
    '';
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.local.dock;
  inherit (pkgs) stdenv;
  inherit (config.homebrew) brewPrefix;
  # dockutil = pkgs.dockutil;
  # dockutil = import ./dockutil.nix;
  normalize = path:
    if lib.hasSuffix ".app" path
    then path + "/"
    else path;
  entryURI = path:
    "file://"
    + (builtins.replaceStrings
      [" " "!" ''"'' "#" "$" "%" "&" "'" "(" ")"]
      ["%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29"]
      (normalize path));
  wantURIs =
    lib.concatMapStrings (entry: ''
      ${entryURI entry.path}
    '')
    cfg.entries;

  createEntries =
    lib.concatMapStrings (entry: ''
      ${brewPrefix}/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}
    '')
    cfg.entries;
in {
  options = {
    local.dock.enable = mkOption {
      description = "Enable dock";
      default = stdenv.isDarwin;
      example = false;
    };

    local.dock.entries =
      mkOption
      {
        description = "Entries on the Dock";
        type = with types;
          listOf (submodule {
            options = {
              path = lib.mkOption {type = str;};
              section = lib.mkOption {
                type = str;
                default = "apps";
              };
              options = lib.mkOption {
                type = str;
                default = "";
              };
            };
          });
        readOnly = true;
      };
  };
  config = lib.mkMerge [
    # (lib.mkIf cfg.enable {
    #   assertions = [
    #     {
    #       assertion = config.module.programs.homebrew.enable;
    #       message = "homebrew must be enabled to use the dock module";
    #     }
    #   ];
    # })

    (lib.mkIf cfg.enable {
      # && config.module.programs.homebrew.enable) {
      # TODO: move back to nix package eventually - can re-enable in darwin.nix
      homebrew.brews = ["dockutil"];

      system.activationScripts.postUserActivation.text = ''
        echo >&2 "Setting up the Dock..."
        haveURIs="$(${brewPrefix}/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
        if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2 ; then
          echo >&2 "Resetting Dock."
          ${brewPrefix}/dockutil --no-restart --remove all
          ${createEntries}
          killall Dock
        else
          echo >&2 "Dock setup complete."
        fi
      '';
    })
  ];
  # config =
  #   mkIf (cfg.enable)
  #   (
  #     let
  #       normalize = path:
  #         if hasSuffix ".app" path
  #         then path + "/"
  #         else path;
  #       entryURI = path:
  #         "file://"
  #         + (
  #           builtins.replaceStrings
  #           [" " "!" "\"" "#" "$" "%" "&" "'" "(" ")"]
  #           ["%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29"]
  #           (normalize path)
  #         );
  #       wantURIs =
  #         concatMapStrings
  #         (entry: "${entryURI entry.path}\n")
  #         cfg.entries;
  #       createEntries =
  #         concatMapStrings
  #         (entry: "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}\n")
  #         cfg.entries;
  #     in {
  #       system.activationScripts.postUserActivation.text = ''
  #         echo >&2 "Setting up the Dock..."
  #         haveURIs="$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
  #         if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2 ; then
  #           echo >&2 "Resetting Dock."
  #           ${dockutil}/bin/dockutil --no-restart --remove all
  #           ${createEntries}
  #           killall Dock
  #         else
  #           echo >&2 "Dock setup complete."
  #         fi
  #       '';
  #     }
  #   );
}

{
  homeDirectory,
  lib,
  private,
  ...
}: let
  isWorkMachine =
    if (!lib.hasAttr "personal" private || !private.personal)
    then "true"
    else "";
in {
  # general settings
  GITHUB_TOKEN = private.githubSecret;
  WORKMACHINE = isWorkMachine;

  # general tool settings
  EDITOR = "nvim";
  LESS = "-R";
  N_PREFIX = "$HOME/.n";
  STARSHIP_LOG = "error";

  # go settings
  GOPATH = "${homeDirectory}/go";
  GOPROXY = "direct";
  GOSUMDB = "off";

  # directories
  DOTFILES_DIR = "${homeDirectory}/dotfiles";
  ICLOUD_DIR = "${homeDirectory}/Library/Mobile Documents/com~apple~CloudDocs";
  NOTES_DIR = "${homeDirectory}/projects/sheeley/notes";
  PRIVATE_CMD_DIR = "${homeDirectory}/projects/sheeley/infrastructure/cmd";
  PRIVATE_DATA_DIR = "${homeDirectory}/projects/sheeley/infrastructure/data";
  PRIVATE_TOOLS_DIR = "${homeDirectory}/projects/sheeley/infrastructure";
  TOOLS_DIR = "${homeDirectory}/dotfiles/bin";
  WORK_NOTES_DIR = "${homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Apple Notes";
}

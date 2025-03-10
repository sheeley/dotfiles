{
  config,
  lib,
  private,
  ...
}: {
  # general settings
  GITHUB_TOKEN = "${private.githubSecret}";
  WORKMACHINE = "${toString (!lib.hasAttr "personal" private || !private.personal)}";

  # general tool settings
  EDITOR = "nvim";
  LESS = "-R";
  N_PREFIX = "$HOME/.n";
  STARSHIP_LOG = "error";

  # go settings
  GOPATH = "${config.home.homeDirectory}/go";
  GOPROXY = "direct";
  GOSUMDB = "off";

  # directories
  DOTFILES_DIR = "${config.home.homeDirectory}/dotfiles";
  ICLOUD_DIR = "${config.home.homeDirectory}/Library/Mobile Documents/com~apple~CloudDocs";
  NOTES_DIR = "${config.home.homeDirectory}/projects/sheeley/notes";
  PRIVATE_CMD_DIR = "${config.home.homeDirectory}/projects/sheeley/infrastructure/cmd";
  PRIVATE_DATA_DIR = "${config.home.homeDirectory}/projects/sheeley/infrastructure/data";
  PRIVATE_TOOLS_DIR = "${config.home.homeDirectory}/projects/sheeley/infrastructure";
  TOOLS_DIR = "${config.home.homeDirectory}/dotfiles/bin";
  WORK_NOTES_DIR = "${config.home.homeDirectory}/Library/Mobile Documents/iCloud~md~obsidian/Documents/Apple Notes";
}

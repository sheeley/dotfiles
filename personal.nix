{
  pkgs,
  user,
  ...
}: {
  home-manager.users.${user}.targets.darwin.defaults = {
    "com.apple.Music" = {
      "library-url" = "file:///Users/${user}/Media/Music/Music%20Library.musiclibrary/";
      "media-folder-url" = "file:///Users/${user}/Media/Music/";
    };

    # TODO: try this
    # "com.apple.photolibraryd" = {
    #   SystemLibraryPath = "/Users/${user}/Media/Photos Library.photoslibrary";
    # };
  };
}

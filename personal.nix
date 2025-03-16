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

    # REVIEW: try this to manage photo library location? is that something I want to do?
    # "com.apple.photolibraryd" = {
    #   SystemLibraryPath = "/Users/${user}/Media/Photos Library.photoslibrary";
    # };
  };
}

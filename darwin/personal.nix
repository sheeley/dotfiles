{
  # pkgs,
  user,
  ...
}: {
  home-manager.users.${user} = {
    home = {
      activation = {
        enableRemoteAccess = ''
          # ssh
          sudo systemsetup -setremotelogin on

          # screen sharing
          # TODO: this does not work.
          sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
          sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
        '';
      };
    };
    targets.darwin.defaults = {
      "com.apple.Music" = {
        "library-url" = "file:///Users/${user}/Media/Music/Music%20Library.musiclibrary/";
        "media-folder-url" = "file:///Users/${user}/Media/Music/";
      };

      # REVIEW: try this to manage photo library location? is that something I want to do?
      # "com.apple.photolibraryd" = {
      #   SystemLibraryPath = "/Users/${user}/Media/Photos Library.photoslibrary";
      # };
    };
  };
}

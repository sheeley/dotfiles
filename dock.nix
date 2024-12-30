{...}: {
  imports = [
    ./dock
  ];

  local.dock.enable = true;
  local.dock.entries = [
    # {path = "/Applications/iTerm.app/";}
    {path = "/Applications/Ghostty.app/";}
    {path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app";}
    {path = "/System/Applications/Mail.app/";}
    {path = "/System/Applications/Calendar.app/";}
    {path = "/System/Applications/Messages.app/";}
    {path = "/System/Applications/Reminders.app/";}
    {path = "/Applications/Obsidian.app/";}
    {path = "/System/Applications/Music.app/";}
    {path = "/Applications/Slack.app/";}

    {
      path = "/Applications/";
      section = "others";
      options = "--sort name --view grid --display folder";
    }
    {
      path = toString ~/Downloads;
      section = "others";
      options = "--sort dateadded --view fan --display stack";
    }
    {
      path = toString ~/Screenshots;
      section = "others";
      options = "--sort dateadded --view fan --display stack";
    }
  ];
}

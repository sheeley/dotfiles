{
  pkgs,
  user,
  private,
  ...
}: let
in {
  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = with pkgs; [
    fish
    zsh
  ];

  users.users.${user} = {
    # FUTURE: nix-darwin can't manage login shell yet
    shell = pkgs.zsh;
    name = user;
    home = "/Users/${user}";
  };

  # fonts.enableFontDir = true;
  fonts.fonts = [
    pkgs.nerdfonts
  ];

  #system.keyboard.enableKeyMapping = true;
  security.pam.enableSudoTouchIdAuth = true;

  system.activationScripts = {
    preActivation.text = ''
      DIRS=(
      	"$HOME/.ssh/control"
      	"$HOME/Screenshots"
      	"$HOME/projects/sheeley"
      	"$HOME/bin"
      	"$HOME/scratch"
      )
      for DIR in "''${DIRS[@]}"; do
      	mkdir -p "$DIR"
      	chown -R ${user} "$DIR"
      done
    '';

    postActivation.text = ''
            # (
            #   cd ./tools/meeting-notes
            #   ./install
            # )

            # TODO: remove these when they can be moved into nix-darwin defaults
      defaults write com.googlecode.iterm2 "GlobalKeyMap" '
                        <dict>
                        	<key>0x19-0x60000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>39</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0x50-0x120000-0x23</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>12</integer>
                        		<key>Label</key>
                        		<string></string>
                        		<key>Text</key>
                        		<string>:Telescope commands\n</string>
                        		<key>Version</key>
                        		<integer>1</integer>
                        	</dict>
                        	<key>0x70-0x100000-0x23</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>12</integer>
                        		<key>Label</key>
                        		<string></string>
                        		<key>Text</key>
                        		<string>:Telescope find_files\n</string>
                        		<key>Version</key>
                        		<integer>1</integer>
                        	</dict>
                        	<key>0x9-0x40000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>32</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf700-0x300000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>7</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf701-0x300000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>6</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf702-0x300000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>2</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf702-0x320000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>33</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf703-0x300000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>0</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf703-0x320000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>34</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf729-0x100000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>5</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf72b-0x100000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>4</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf72c-0x100000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>9</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf72c-0x20000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>9</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf72d-0x100000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>8</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        	<key>0xf72d-0x20000</key>
                        	<dict>
                        		<key>Action</key>
                        		<integer>8</integer>
                        		<key>Text</key>
                        		<string></string>
                        	</dict>
                        </dict>
                        '

                        defaults write com.crowdcafe.windowmagnet "centerWindowComboKey" '<dict/>'
                  defaults write com.crowdcafe.windowmagnet "expandWindowCenterThirdComboKey" '<dict/>'
                  defaults write com.crowdcafe.windowmagnet "expandWindowEastComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>124</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "expandWindowLeftThirdComboKey" '<dict/>'
                  defaults write com.crowdcafe.windowmagnet "expandWindowLeftTwoThirdsComboKey" '<dict/>'
                  defaults write com.crowdcafe.windowmagnet "expandWindowNorthComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>126</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "expandWindowNorthEastComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>19</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "expandWindowNorthWestComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>18</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "expandWindowRightThirdComboKey" '<dict/>'
                  defaults write com.crowdcafe.windowmagnet "expandWindowRightTwoThirdsComboKey" '<dict/>'
                  defaults write com.crowdcafe.windowmagnet "expandWindowSouthComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>125</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "expandWindowSouthEastComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>21</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "expandWindowSouthWestComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>20</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "expandWindowWestComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>123</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "lastRatedVersion" -string '2.11.0'
                  defaults write com.crowdcafe.windowmagnet "launchAtLogin" -boolean true
                  defaults write com.crowdcafe.windowmagnet "maximizeWindowComboKey" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>3</integer>
                  	<key>modifierFlags</key>
                  	<integer>1835008</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "moveWindowToNextDisplay" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>123</integer>
                  	<key>modifierFlags</key>
                  	<integer>1310720</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "moveWindowToPreviousDisplay" '
                  <dict>
                  	<key>keyCode</key>
                  	<integer>124</integer>
                  	<key>modifierFlags</key>
                  	<integer>1310720</integer>
                  </dict>
                  '
                  defaults write com.crowdcafe.windowmagnet "restoreWindowComboKey" '<dict/>'
    '';
  };
}

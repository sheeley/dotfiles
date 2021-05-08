#!/usr/bin/env bash

defaults write com.apple.finder "CopyProgressWindowLocation" -string '{151, 645}'
defaults write com.apple.finder "EmptyTrashProgressWindowLocation" -string '{520, 228}'
defaults write com.apple.finder "FXArrangeGroupViewBy" -string 'Name'
defaults write com.apple.finder "FXDesktopTouchBarUpgradedToTenTwelveOne" -integer 1
defaults write com.apple.finder "FXDesktopVolumePositions" '
<dict>
	<key>Google Chrome_0x1.188574f8p+29</key>
	<dict>
		<key>AnchorRelativeTo</key>
		<integer>1</integer>
		<key>ScreenID</key>
		<integer>0</integer>
		<key>xRelative</key>
		<integer>-187</integer>
		<key>yRelative</key>
		<integer>175</integer>
	</dict>
	<key>Slack.app_0x1.1709e3ep+29</key>
	<dict>
		<key>AnchorRelativeTo</key>
		<integer>1</integer>
		<key>ScreenID</key>
		<integer>0</integer>
		<key>xRelative</key>
		<integer>-65</integer>
		<key>yRelative</key>
		<integer>63</integer>
	</dict>
</dict>
'
defaults write com.apple.finder "FXICloudDriveDeclinedUpgrade" -boolean false
defaults write com.apple.finder "FXICloudDriveDesktop" -boolean true
defaults write com.apple.finder "FXICloudDriveDocuments" -boolean true
defaults write com.apple.finder "FXICloudDriveEnabled" -boolean true
defaults write com.apple.finder "FXICloudLoggedIn" -boolean true
defaults write com.apple.finder "FXInfoPanesExpanded" '
<dict>
	<key>Comments</key>
	<false/>
	<key>MetaData</key>
	<true/>
	<key>Name</key>
	<true/>
	<key>Privileges</key>
	<true/>
</dict>
'
defaults write com.apple.finder "FXPreferredGroupBy" -string 'None'
defaults write com.apple.finder "FXQuickActionsConfigUpgradeLevel" -integer 1
defaults write com.apple.finder "FXToolbarUpgradedToTenEight" -integer 1
defaults write com.apple.finder "FXToolbarUpgradedToTenNine" -integer 2
defaults write com.apple.finder "NewWindowTarget" -string 'PfHm'
defaults write com.apple.finder "RecentsArrangeGroupViewBy" -string 'Date Last Opened'
defaults write com.apple.finder "ViewOptionsWindow.Location" -string '{983, 100}'
start_application -r -a "Finder"
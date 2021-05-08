#!/usr/bin/env bash

defaults write com.omnigroup.OmniFocus3 "AutomaticAlarmDeferredEnabled" -boolean true
defaults write com.omnigroup.OmniFocus3 "BorrowedOmniAccountLoginIdentifiers" '
<array>
	<string>sheeley</string>
</array>
'
defaults write com.omnigroup.OmniFocus3 "ForecastCalendarCollapsed" -boolean false
defaults write com.omnigroup.OmniFocus3 "OFIColorPaletteIdentifier" -string 'default'
defaults write com.omnigroup.OmniFocus3 "PerspectiveFavorites" '
<array>
	<string>ProcessForecast.v2</string>
	<string>ProcessInbox.v2</string>
	<string>ProcessProjects.v2</string>
	<string>ProcessTags.v3</string>
	<string>ProcessFlaggedItems.v2</string>
	<string>ProcessReview.v2</string>
</array>
'
defaults write com.omnigroup.OmniFocus3 "PreferredVisibleColumnNames" '
<array>
	<string>dateToStart</string>
	<string>dateDue</string>
	<string>noteExists</string>
	<string>flagged</string>
</array>
'
defaults write com.omnigroup.OmniFocus3 "TitleTextFoldingForColumns" -boolean false
defaults write com.omnigroup.OmniFocus3 "TryPro" -boolean true

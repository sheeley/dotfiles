#!/usr/bin/env bash

defaults write com.if.Amphetamine "Adjust Volume For CDM Warning" -integer 0
defaults write com.if.Amphetamine "Allow Closed-Display Sleep" -integer 1
defaults write com.if.Amphetamine "Allow Display Sleep" -integer 0
defaults write com.if.Amphetamine "Allow Display Sleep When Screen Is Locked" -integer 1
defaults write com.if.Amphetamine "Allow Screen Saver" -integer 0
defaults write com.if.Amphetamine "Always Ask to End For Low Battery" -integer 0
defaults write com.if.Amphetamine "Auto Remove Notifications" -integer 1
defaults write com.if.Amphetamine "Default Duration" -integer 0
defaults write com.if.Amphetamine "DefaultHotkeyAction" -integer 0
defaults write com.if.Amphetamine "Drive Alive Data" '<array/>'
defaults write com.if.Amphetamine "Drive Wake Interval" -string '10'
defaults write com.if.Amphetamine "Enable CDM Warning" -integer 0
defaults write com.if.Amphetamine "Enable Drive Alive" -integer 0
defaults write com.if.Amphetamine "Enable Mouse Movement" -integer 0
defaults write com.if.Amphetamine "Enable Notification Sound" -integer 0
defaults write com.if.Amphetamine "Enable Session Auto End Notifications" -integer 0
defaults write com.if.Amphetamine "Enable Session Auto Start Notifications" -integer 0
defaults write com.if.Amphetamine "Enable Session Extend Sound" -integer 0
defaults write com.if.Amphetamine "Enable Session Notifications" -integer 0
defaults write com.if.Amphetamine "Enable Session State Sound" -integer 0
defaults write com.if.Amphetamine "Enable Statistics" -integer 1
defaults write com.if.Amphetamine "Enable Triggers" -integer 0
defaults write com.if.Amphetamine "End Session On Low Battery" -integer 0
defaults write com.if.Amphetamine "End Sessions On Forced Sleep" -integer 1
defaults write com.if.Amphetamine "End Sessions when FUS" -integer 0
defaults write com.if.Amphetamine "Hide Dock Icon" -integer 1
defaults write com.if.Amphetamine "Icon Style" -integer 5
defaults write com.if.Amphetamine "Ignore Battery on AC" -integer 0
defaults write com.if.Amphetamine "Lock Screen After Inactivity" -integer 0
defaults write com.if.Amphetamine "Lock Screen For CDM" -integer 0
defaults write com.if.Amphetamine "Lock Screen Inactivity Delay" -integer 60
defaults write com.if.Amphetamine "Low Battery Percent" -integer 10
defaults write com.if.Amphetamine "Lower Icon Opacity" -integer 1
defaults write com.if.Amphetamine "Manage Status Item Image Padding" -integer 0
defaults write com.if.Amphetamine "Mouse Movement Inactivity Delay" -integer 300
defaults write com.if.Amphetamine "Mouse Movement Interval" -integer 60
defaults write com.if.Amphetamine "Mouse Movement Smoothness" -integer 1
defaults write com.if.Amphetamine "NSStatusItem Preferred Position Amphetamine" -float 450.5
defaults write com.if.Amphetamine "NSStatusItem Preferred Position Item-0" -float 412.5
defaults write com.if.Amphetamine "Notification Sound End" -integer 0
defaults write com.if.Amphetamine "Notification Sound Start" -integer 0
defaults write com.if.Amphetamine "Reduce Motion" -integer 0
defaults write com.if.Amphetamine "Repeat CDM Warning" -integer 0
defaults write com.if.Amphetamine "Repeat Interval For CDM Warning" -integer 300
defaults write com.if.Amphetamine "Restart DD Session on AC Reconnect" -integer 0
defaults write com.if.Amphetamine "Screen Lock Uses Mouse Activity" -integer 0
defaults write com.if.Amphetamine "Screen Saver Delay" -integer 5
defaults write com.if.Amphetamine "Session End Time Calcuation" -integer 0
defaults write com.if.Amphetamine "Session Notification Interval" -integer 60
defaults write com.if.Amphetamine "Show Seconds In Bar Time Remaining" -integer 0
defaults write com.if.Amphetamine "Show Session Details In Menu" -integer 1
defaults write com.if.Amphetamine "Show Session Time In Status Bar" -integer 0
defaults write com.if.Amphetamine "Show Welcome Window" -integer 0
defaults write com.if.Amphetamine "Show Woke Drives In Menu" -integer 0
defaults write com.if.Amphetamine "Start Session At Launch" -integer 0
defaults write com.if.Amphetamine "Start Session On Wake" -integer 0
defaults write com.if.Amphetamine "StartNewSessionHotkeyDuration" -integer 0
defaults write com.if.Amphetamine "Status Bar Font Size" -integer 0
defaults write com.if.Amphetamine "Status Bar Session Time Format" -integer 0
defaults write com.if.Amphetamine "Status Item Click" -integer 2
defaults write com.if.Amphetamine "Status Item Image Padding" -integer 8
defaults write com.if.Amphetamine "Stop Mouse Movement" -integer 0
defaults write com.if.Amphetamine "Stop Mouse Movement Inactivity Delay" -integer 1800
defaults write com.if.Amphetamine "Suppress Closed Display Warning" -boolean false
defaults write com.if.Amphetamine "Trigger Data" '<array/>'
defaults write com.if.Amphetamine "Use 24 Hour Clock" -integer 0
defaults write com.if.Amphetamine "Volume Level For CDM Warning" -integer 5
defaults write com.if.Amphetamine "cdmEnabled" -boolean false
start_application -r -a "Amphetamine"
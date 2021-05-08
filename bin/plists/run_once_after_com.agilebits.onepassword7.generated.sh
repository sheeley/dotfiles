#!/usr/bin/env bash

defaults write com.agilebits.onepassword7 "OPPrefShowSafariInlineMenu" -boolean false
defaults write com.agilebits.onepassword7 "OPPrefShowSafariInlineMenuAutomatically" -boolean false
defaults write com.agilebits.onepassword7 "OPPreferencesNotifyCompromisedWebsites" -boolean true
defaults write com.agilebits.onepassword7 "ShortcutRecorder BrowserActivation" '
<dict>
	<key>keyCode</key>
	<integer>-1</integer>
	<key>modifierFlags</key>
	<integer>0</integer>
	<key>modifiers</key>
	<integer>0</integer>
</dict>
'
defaults write com.agilebits.onepassword7 "ShortcutRecorder GlobalActivation" '
<dict>
	<key>keyCode</key>
	<integer>-1</integer>
	<key>modifierFlags</key>
	<integer>0</integer>
	<key>modifiers</key>
	<integer>0</integer>
</dict>
'
defaults write com.agilebits.onepassword7 "ShortcutRecorder GlobalLock" '
<dict>
	<key>keyCode</key>
	<integer>-1</integer>
	<key>modifierFlags</key>
	<integer>0</integer>
	<key>modifiers</key>
	<integer>0</integer>
</dict>
'
start_application -r -a "1Password 7"
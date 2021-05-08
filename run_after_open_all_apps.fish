#!/usr/bin/env fish

set applications AirBuddy Clocker "1Password 7" Amphetamine "Bartender 4" Bear ShiftIt
for app in $applications
	start_application -a $app.app
end

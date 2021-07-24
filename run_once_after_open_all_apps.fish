#!/usr/bin/env fish
if set -q $VIM
    exit
end

set applications AirBuddy Clocker "1Password 7" Amphetamine "Bartender 4" Bear ShiftIt
for app in $applications
    start_application -a $app.app
end

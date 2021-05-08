#!/usr/bin/env bash

defaults write net.shinyfrog.bear "SFAppIconMatchesTheme" -boolean false
defaults write net.shinyfrog.bear "SFAppThemeName" -string 'Solarized Dark'
defaults write net.shinyfrog.bear "SFAutoGrabURLTitles" -boolean false
defaults write net.shinyfrog.bear "SFEditorLineWidthMultiplier" -float 65
defaults write net.shinyfrog.bear "SFFirstLaunchNotes" -boolean true
defaults write net.shinyfrog.bear "SFFoldCompletedTodo" -integer 0
defaults write net.shinyfrog.bear "SFNoteTextViewAutomaticSpellingCorrectionEnabled" -boolean false
defaults write net.shinyfrog.bear "SFNoteTextViewContinuousSpellCheckingEnabled" -boolean true
defaults write net.shinyfrog.bear "SFNoteTextViewGrammarCheckingEnabled" -boolean false
defaults write net.shinyfrog.bear "SFTagsListSortAscending" -boolean true
defaults write net.shinyfrog.bear "SFTagsListSortBy" -string 'title'
start_application -r -a "Bear"
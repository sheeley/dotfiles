#!/usr/bin/env xcrun swift
import Foundation
import os

let myAppleScript = """
on getMicrophoneVolume()
  input volume of (get volume settings)
end getMicrophoneVolume

on disableMicrophone()
  set volume input volume 0
end disableMicrophone

on enableMicrophone()
  set volume input volume 100
end enableMicrophone

if getMicrophoneVolume() is greater than 0 then
  disableMicrophone()
else
  enableMicrophone()
end if
"""
var error: NSDictionary?
guard let scriptObject = NSAppleScript(source: myAppleScript) else {
    exit(1)
}

_ = scriptObject.executeAndReturnError(&error)
if let error {
    print("error: \(error)")
}

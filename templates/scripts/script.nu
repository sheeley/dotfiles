#! /usr/bin/env nu --stdin

def main [
positional: string, # foo documentation
--named: bool, # named
...files # Files to open

] {
  echo $"stdin: ($in)"
}

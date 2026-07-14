#!/usr/bin/env bats

load '../test_helper'

# Source the real macForge so we can call internal functions directly.
# The guard we added to macForge prevents main() from running when sourced.
setup() {
  setup_test_env
  source_macforge
}

teardown() {
  teardown_test_env
}

@test "guess_cask_token maps known apps correctly" {
  run guess_cask_token "Brave Browser.app"
  [ "$status" -eq 0 ]
  [ "$output" = "brave-browser" ]

  run guess_cask_token "Cursor.app"
  [ "$output" = "cursor" ]

  run guess_cask_token "iTerm.app"
  [ "$output" = "iterm2" ]

  run guess_cask_token "Visual Studio Code.app"
  [ "$output" = "visual-studio-code" ]

  run guess_cask_token "LastPass.app"
  [ "$output" = "lastpass" ]
}

@test "guess_cask_token returns empty for unknown apps" {
  run guess_cask_token "Grok Desktop.app"
  [ "$output" = "" ]

  run guess_cask_token "Some Totally Unknown App.app"
  [ "$output" = "" ]
}
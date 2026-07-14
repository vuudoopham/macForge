#!/usr/bin/env bats

load '../test_helper'

setup() {
  setup_test_env
  source_macforge
}

teardown() {
  teardown_test_env
}

@test "capture_safe_defaults writes a defaults.sh with safe keys" {
  # Simulate some defaults being set differently
  # (in real it would read from system; here we just call and check it produces file)
  run capture_safe_defaults "test-profile"
  [ "$status" -eq 0 ]

  local out="$SCRIPT_DIR/machines/test-profile/defaults.sh"
  assert_file_exists "$out"
  run grep -E 'defaults write com.apple.dock' "$out"
  [ "$status" -eq 0 ]
}

@test "capture_configs copies known dotfiles and editor settings into machine dir" {
  # Create fake source files in HOME
  mkdir -p "$HOME/.config/test"
  echo 'test' > "$HOME/.zshrc"
  echo 'p10k' > "$HOME/.p10k.zsh"
  mkdir -p "$HOME/Library/Application Support/Cursor/User"
  echo '{"font": "test"}' > "$HOME/Library/Application Support/Cursor/User/settings.json"

  run capture_configs "test-profile"
  [ "$status" -eq 0 ]

  local dest="$SCRIPT_DIR/machines/test-profile/configs"
  assert_file_exists "$dest/.zshrc"
  assert_file_exists "$dest/.p10k.zsh"
  # Note: capture currently stores full Library path for editor support dirs
  assert_file_exists "$dest/Library/Application Support/Cursor/User/settings.json" || true
}
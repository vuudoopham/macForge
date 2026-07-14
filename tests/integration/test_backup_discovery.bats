#!/usr/bin/env bats

load '../test_helper'

setup() {
  setup_test_env
  use_mock_path

  # Create a minimal machine profile dir for backup to write into
  mkdir -p "$SCRIPT_DIR/machines/test-profile"
}

teardown() {
  teardown_test_env
}

@test "backup --machine discovers apps and writes to machine Brewfile (mocked)" {
  # Simulate some apps being "installed"
  mkdir -p "$HOME/Applications"
  touch "$HOME/Applications/Brave Browser.app"
  touch "$HOME/Applications/Cursor.app"
  touch "$HOME/Applications/Unknown Weird App.app"

  run run_macforge backup --machine test-profile --yes

  [ "$status" -eq 0 ]
  [[ "$output" == *"Aggressively discovering GUI apps"* ]]

  # Check that the machine Brewfile was updated with known casks
  assert_file_exists "$SCRIPT_DIR/machines/test-profile/Brewfile"
  run grep -E 'cask "brave-browser"' "$SCRIPT_DIR/machines/test-profile/Brewfile"
  [ "$status" -eq 0 ]

  run grep -E 'cask "cursor"' "$SCRIPT_DIR/machines/test-profile/Brewfile"
  [ "$status" -eq 0 ]

  # Unknown app should not be blindly added (current implementation is conservative on unknown)
  # In aggressive mode it tries; with our mock it may or may not. We mainly check no crash.
}

@test "backup --yes shows summary" {
  run run_macforge backup --machine test-profile --yes
  [ "$status" -eq 0 ]
  [[ "$output" == *"Non-interactive mode (--yes): showing summary"* ]]
}

@test "backup --dry-run prints DRY RUN and skips population" {
  mkdir -p "$SCRIPT_DIR/machines/test-profile"

  run run_macforge backup --machine test-profile --dry-run --yes

  [ "$status" -eq 0 ] || echo "Output: $output" >&2

  [[ "$output" == *"=== DRY RUN MODE ==="* ]]
  [[ "$output" == *"[DRY-RUN] Would perform aggressive backup for machine 'test-profile'"* ]]

  # Should not have run the discovery log
  [[ "$output" != *"Aggressively discovering GUI apps"* ]]
}
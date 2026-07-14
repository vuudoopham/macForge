#!/usr/bin/env bats

load '../test_helper'

setup() {
  setup_test_env
  use_mock_path
}

teardown() {
  teardown_test_env
}

@test "backup generates MANUAL.md matching golden for minimal profile" {
  # Use fixture which has minimal Brewfile
  FIXTURE_DIR="/Users/vupham/Projects/macFoundry/tests/fixtures/minimal-personal"
  TARGET_MACHINE_DIR="$SCRIPT_DIR/machines/golden-test"
  mkdir -p "$TARGET_MACHINE_DIR"
  cp -r "$FIXTURE_DIR/"* "$TARGET_MACHINE_DIR/"

  # Run backup --yes (will use mocks for brew)
  run run_macforge backup --machine golden-test --yes
  [ "$status" -eq 0 ]

  # Compare generated MANUAL to golden
  GOLDEN="/Users/vupham/Projects/macFoundry/tests/fixtures/expected/minimal-personal-MANUAL.md"
  GENERATED="$TARGET_MACHINE_DIR/MANUAL.md"

  assert_file_exists "$GENERATED"
  run diff -u "$GOLDEN" "$GENERATED"
  [ "$status" -eq 0 ] || {
    echo "Golden diff failed:"
    echo "$output"
    return 1
  }
}
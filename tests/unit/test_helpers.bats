#!/usr/bin/env bats

load '../test_helper'

setup() {
  setup_test_env
  source_macforge
}

teardown() {
  teardown_test_env
}

@test "machine_dir returns correct path" {
  result=$(machine_dir "personal")
  [ "$result" = "$SCRIPT_DIR/machines/personal" ]
}

@test "machine_brewfile returns correct path" {
  result=$(machine_brewfile "work")
  [ "$result" = "$SCRIPT_DIR/machines/work/Brewfile" ]
}

@test "machine_configs_dir returns correct path" {
  result=$(machine_configs_dir "personal")
  [ "$result" = "$SCRIPT_DIR/machines/personal/configs" ]
}

@test "machine_manual returns correct path" {
  result=$(machine_manual "test")
  [ "$result" = "$SCRIPT_DIR/machines/test/MANUAL.md" ]
}
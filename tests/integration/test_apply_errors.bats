#!/usr/bin/env bats

load '../test_helper'

setup() {
  setup_test_env
  use_mock_path
}

teardown() {
  teardown_test_env
}

@test "apply fails with clear error when machine profile does not exist" {
  run run_macforge apply --machine nonexistent-profile
  [ "$status" -eq 1 ]
  [[ "$output" == *"Machine profile not found"* ]] || [[ "$output" == *"not found"* ]]
}

@test "apply fails when --machine is not provided" {
  run run_macforge apply
  [ "$status" -eq 1 ]
  [[ "$output" == *"--machine is required"* ]]
}
#!/usr/bin/env bats

load '../test_helper'

setup() {
  setup_test_env
}

teardown() {
  teardown_test_env
}

@test "macForge prints usage when run with no arguments" {
  run run_macforge
  [ "$status" -eq 1 ]
  [[ "$output" == *"macForge - Reproducible multi-machine macOS setup"* ]]
}

@test "macForge accepts --help" {
  run run_macforge --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Commands:"* ]]
  [[ "$output" == *"apply"* ]]
  [[ "$output" == *"backup"* ]]
}

@test "macForge rejects unknown arguments" {
  run run_macforge --foo-bar
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unknown arg"* ]]
}
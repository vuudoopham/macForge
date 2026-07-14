#!/usr/bin/env bats

load '../test_helper'

setup() {
  setup_test_env
  source_macforge
  # Create a temp data file for testing
  export TEST_DATA_FILE="$TEST_TMPDIR/test-apps-requiring-login.txt"
  mkdir -p "$(dirname "$TEST_DATA_FILE")"
}

teardown() {
  teardown_test_env
}

@test "report_no_scripted_login uses data file when present" {
  cat > "$TEST_DATA_FILE" <<EOF
# comment
LastPass (GUI or lpass)
Moom (license)
EOF

  DATA_FILE="$TEST_DATA_FILE" run report_no_scripted_login "test-machine"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Applications installed that do not support scripted login:"* ]]
  [[ "$output" == *"LastPass (GUI or lpass)"* ]]
  [[ "$output" == *"Moom (license)"* ]]
}

@test "report_no_scripted_login falls back gracefully when data file missing" {
  # Unset or point to non-existent
  run report_no_scripted_login "test-machine"
  [ "$status" -eq 0 ]
  [[ "$output" == *"LastPass (log in via GUI or lpass)"* ]]
  [[ "$output" == *"ExpressVPN, Tailscale, Moom"* ]]
}
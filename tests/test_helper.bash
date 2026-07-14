#!/usr/bin/env bash
# Common test helper for macForge BATS tests

# Default to a clean temp HOME and temp SCRIPT_DIR for most tests
setup_test_env() {
  export TEST_TMPDIR="$(mktemp -d)"
  export HOME="$TEST_TMPDIR/home"
  export SCRIPT_DIR="$TEST_TMPDIR/macforge"
  mkdir -p "$HOME" "$SCRIPT_DIR"

  # Copy the real macForge into the temp SCRIPT_DIR
  cp /Users/vupham/Projects/macFoundry/macForge "$SCRIPT_DIR/macForge"
  chmod +x "$SCRIPT_DIR/macForge"

  # Provide a minimal Brewfile.common so package installation steps don't explode
  echo '# minimal for tests' > "$SCRIPT_DIR/Brewfile.common"

  # Default mock log
  export MOCK_LOG="$TEST_TMPDIR/mock.log"
  touch "$MOCK_LOG"
}

teardown_test_env() {
  if [[ -n "$TEST_TMPDIR" && -d "$TEST_TMPDIR" ]]; then
    rm -rf "$TEST_TMPDIR"
  fi
  unset TEST_TMPDIR HOME SCRIPT_DIR MOCK_LOG
}

# Use mock commands from tests/bin (prepend to PATH)
use_mock_path() {
  export PATH="/Users/vupham/Projects/macFoundry/tests/bin:$PATH"
}

# Restore original PATH (usually not needed due to per-test env)
restore_path() {
  # In practice, we rely on the test subshell
  :
}

# Run the macForge script directly (preferred for most CLI tests)
run_macforge() {
  "$SCRIPT_DIR/macForge" "$@"
}

# Source the script so that individual functions can be called in unit tests
# (the guard we added prevents main() from running on source).
source_macforge() {
  # shellcheck source=/dev/null
  source "$SCRIPT_DIR/macForge"
}

# Simple path assertion helpers (can be expanded with bats-file later)
assert_file_exists() {
  if [[ ! -f "$1" ]]; then
    echo "Expected file to exist: $1" >&2
    return 1
  fi
}

assert_dir_exists() {
  if [[ ! -d "$1" ]]; then
    echo "Expected directory to exist: $1" >&2
    return 1
  fi
}
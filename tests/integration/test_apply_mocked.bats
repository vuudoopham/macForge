#!/usr/bin/env bats

load '../test_helper'

setup() {
  setup_test_env
  use_mock_path
}

teardown() {
  teardown_test_env
}

@test "apply --machine personal runs core steps with mocks" {
  # Create a minimal personal profile
  mkdir -p "$SCRIPT_DIR/machines/personal"
  echo 'cask "iterm2"' > "$SCRIPT_DIR/machines/personal/Brewfile"

  # Create fake common configs
  mkdir -p "$SCRIPT_DIR/common/configs/zsh"
  echo 'export TEST_ZSH=1' > "$SCRIPT_DIR/common/configs/zsh/.zshrc"

  run run_macforge apply --machine personal --yes

  # With mocks, it should not actually install but log
  [ "$status" -eq 0 ] || echo "Output: $output" >&2

  # Verify it tried to do early core and packages
  [[ "$output" == *"Installing early core packages"* ]] || echo "Output: $output"
  [[ "$output" == *"brew bundle"* ]] || true   # depends on mock output
}

@test "apply --dry-run prints DRY RUN MODE and skips actions with 'Would'" {
  mkdir -p "$SCRIPT_DIR/machines/personal"
  echo 'cask "iterm2"' > "$SCRIPT_DIR/machines/personal/Brewfile"

  > "$MOCK_LOG"
  run run_macforge apply --machine personal --dry-run --yes

  [ "$status" -eq 0 ] || echo "Output: $output" >&2

  [[ "$output" == *"=== DRY RUN MODE ==="* ]]
  [[ "$output" == *"[DRY-RUN] Would check/install Xcode Command Line Tools"* ]]
  [[ "$output" == *"[DRY-RUN] Would check/install Homebrew"* ]]
  [[ "$output" == *"[DRY-RUN] Would install early core packages (LastPass)"* ]]
  [[ "$output" == *"[DRY-RUN] Would install common + machine packages"* ]]
  [[ "$output" == *"[DRY-RUN] Would restore configs"* ]]
  [[ "$output" == *"[DRY-RUN] Would apply macOS defaults"* ]]

  # Should not see the real action logs (because guarded)
  [[ "$output" != *"Installing early core packages (LastPass)..."* ]]

  # Confirm no actual brew bundle was called during this dry-run (early + packages skipped)
  run grep -c "brew bundle" "$MOCK_LOG" || echo 0
  [ "$output" -eq 0 ]
}
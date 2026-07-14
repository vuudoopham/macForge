#!/usr/bin/env bash
# Convenience runner for macForge tests

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

echo "Running macForge test suite..."

if ! command -v bats >/dev/null 2>&1; then
  echo "bats not found. Install with: brew install bats-core bats-support bats-assert bats-file"
  exit 1
fi

echo "== Unit tests =="
bats tests/unit/

echo
echo "== Integration tests =="
bats tests/integration/

echo
echo "All tests completed."
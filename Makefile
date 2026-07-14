# Makefile for macForge development tasks

.PHONY: test test-unit test-integration lint install-bats help

help:
	@echo "macForge development commands:"
	@echo "  make test             - Run all tests"
	@echo "  make test-unit        - Run unit tests only"
	@echo "  make test-integration - Run integration tests only"
	@echo "  make lint             - Run ShellCheck"
	@echo "  make install-bats     - Install BATS via Homebrew"

install-bats:
	brew install bats-core bats-support bats-assert bats-file

test: test-unit test-integration

test-unit:
	bats tests/unit/

test-integration:
	bats tests/integration/

lint:
	@command -v shellcheck >/dev/null 2>&1 || { echo "shellcheck not found. brew install shellcheck"; exit 1; }
	shellcheck macForge scripts/*.sh || true

# For CI or when BATS is in PATH
ci-test:
	bats --formatter tap tests/
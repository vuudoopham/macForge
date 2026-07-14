# Testing macForge

## Automated Tests (BATS)

We use [BATS](https://github.com/bats-core/bats-core) for unit and integration tests.

### Running the test suite

```bash
# Install once
brew install bats-core bats-support bats-assert bats-file

# From the project root
bats tests/
```

You can also run subsets:

```bash
bats tests/unit/
bats tests/integration/
```

### Adding tests

- Pure logic (e.g. cask name mapping) → `tests/unit/`
- Flow behavior with mocks → `tests/integration/`
- Real fixture-based or end-to-end scenarios → `tests/` or `tests/e2e/`

See `tests/test_helper.bash` for common setup (temp HOME, copied macForge, etc.).

## Manual / Host testing (recommended for development)

```bash
# Capture changes
./macForge backup --machine personal

# Review (or non-interactive)
./macForge backup --machine personal --yes

# Apply (safe to re-run)
./macForge apply --machine personal --yes
```

Use `--dry-run` where supported for preview.

## Clean testing with Parallels (optional but powerful)

Because you have Parallels:

1. Create a new macOS VM from a clean installer or recovery (no extra apps).
2. Install only the absolute minimum (Xcode CLI if needed for some casks, but usually not).
3. Copy or git-clone the macForge repo into the VM.
4. Run:
   ```bash
   ./macForge apply --machine personal --yes
   ```
5. Verify:
   - All expected apps are present via `brew list --cask`
   - Configs are in place (~/.zshrc, Cursor settings, etc.)
   - No scripted login list is printed and makes sense
   - Defaults are applied

Snapshots allow you to reset to "fresh macOS" quickly.

**Caveats in VM:**
- Some casks may fail or behave differently (graphics, audio, certain hardware-dependent apps).
- You will still need to do the manual login steps listed.

Use the VM for milestone validation ("does a brand new machine + this config actually boot into a usable state?").

## Future

- Add more `--dry-run` coverage.
- Automated smoke tests (list casks, check files exist).

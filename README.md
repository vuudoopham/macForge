# macForge

**Reproducible multi-machine macOS setup.** Define your machines in the repo, run `backup` on a live machine to capture state (aggressively), review, commit. Then `apply` on any fresh (or existing) Mac.

Supports many machines across users (you, wife, friends, etc.). Works even if the user only has a copy of the files (no GitHub account required).

## Core Workflow

### 1. On a configured machine (capture)
```bash
./macForge backup --machine personal
# (or --machine wife-macbook, work, etc.)
```
- Aggressively discovers installed apps and maps them to Homebrew casks.
- Captures your shell, editor, git, and other configs.
- Autocaptures safe portable macOS defaults.
- Produces a `MANUAL.md` with non-automatable items.
- Interactive review (or `--yes` for non-interactive + summary).

Review the diff and commit.

### 2. On a fresh (or target) Mac (reproduce)
```bash
git clone ... ~/macForge
cd ~/macForge
./macForge apply --machine personal
```

The tool will:
- Install Xcode CLI tools + Homebrew
- **Early**: Install LastPass (GUI + CLI) so you can log in immediately
- Prompt you to log into LastPass
- Install everything via `Brewfile.common` + the machine's Brewfile
- Restore configs, editors, safe defaults
- Print a clear list of apps that were installed but **do not support scripted login**

## Important: Applications Without Scripted Login

Even when installed via `brew`, many apps require manual login or activation. After packages are installed, `macForge apply` will print a dedicated section like:

```
Applications installed that do not support scripted login:
  • LastPass (log in via GUI or lpass)
  • ExpressVPN (login + connect)
  • Moom (license key)
  • Parallels Desktop (license + VM setup)
  ...
```

This list is maintained in `data/apps-requiring-login.txt` and appears in per-machine `MANUAL.md`.

## Project Structure (Multi-Machine)

```
.
├── macForge                     # The main tool (apply / backup)
├── Brewfile.common              # Packages for ALL machines (includes lastpass + lastpass-cli early)
├── machines/
│   ├── personal/
│   │   ├── Brewfile             # Extra packages only for this machine
│   │   ├── configs/             # All configs for this machine
│   │   ├── defaults.sh          # (optional) autocaptured safe defaults
│   │   └── MANUAL.md            # Non-automatable items for this machine
│   └── wife-macbook/
│       └── ...
├── common/
│   └── configs/                 # (optional) shared base configs applied first
├── scripts/
│   └── macos-defaults.sh
├── data/
│   └── apps-requiring-login.txt
└── README.md
```

**Per-machine directories** are the primary model (clean isolation, easy to share just one person's setup).

## Using macForge

```bash
# Backup current machine
./macForge backup --machine personal

# Non-interactive (shows summary first)
./macForge backup --machine personal --yes --commit

# Apply a profile
./macForge apply --machine personal
```

**No GitHub / no internet clone required for apply**: As long as you have the directory tree (zip, tar, rsync, shared drive, etc.), `apply` works. It only needs Homebrew on the target Mac.

## Adding a New Machine / User

1. On the new machine:
   ```bash
   git clone ... ~/macForge   # or receive the files another way
   cd ~/macForge
   ./macForge backup --machine wife-macbook
   ```
2. Review, commit/push (or manually send the `machines/wife-macbook/` dir + any common changes back to the repo).

The new profile is now in the repo.

## LastPass

`lastpass` (cask) and `lastpass-cli` (formula) are installed very early in `Brewfile.common`.

During `apply` you get an explicit pause:

> Core tools including LastPass are installed.
> Please open LastPass ... and authenticate now.

## macOS Defaults

A curated set lives in `scripts/macos-defaults.sh` (applied for everyone).

During backup we **autocapture safe portable keys** (Dock, Finder views, keyboard repeat, screenshots, etc.) into `machines/<name>/defaults.sh`. These are sourced after the main script.

Not everything can be safely autocaptured (hardware-specific displays, Apple-ID/iCloud keys, volatile state, version-specific keys, etc.).

## Current Machine Example

See `machines/personal/` for a real (aggressively captured) profile.

## Updating an Existing Machine

Just run `backup` again on it, review the changes (especially newly installed apps), commit.

Re-apply is safe and idempotent.

## Non-Automatable Items

These are collected into `machines/<name>/MANUAL.md` and printed by `apply`.

Common examples:
- Logins (LastPass early, then others)
- License keys for paid apps
- Game content downloads
- First-run / account setup for many apps

## Legacy `./install`

Still works as a thin wrapper for the `personal` machine:

```bash
./install
```

Prefer the explicit `./macForge apply --machine ...` going forward.

## Contributing / Personalization

This repo is designed to hold configurations for multiple people/machines.

- Each person gets their own `machines/<their-name>/`
- Share the whole repo or just specific machine folders
- People without GitHub can still use a copy of the files

---

Run `./macForge --help` for options.
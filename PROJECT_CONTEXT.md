# macForge — Project Context

**Goal**: Build a reproducible, multi-machine macOS bootstrap tool that can capture ("backup") a machine's full state (apps via Homebrew, configs, terminal setup, macOS defaults, editor settings) into a Git repository and perfectly reproduce it ("apply") on a fresh macOS install — including support for multiple users/machines (personal, work, family, friends) and users who only have a file copy (no GitHub).

## Current Focus (as of 2026-06-29)
- Core `macForge` tool implemented with `apply` and `backup` subcommands.
- Aggressive backup: discovers installed .app bundles and maps them to casks; captures dotfiles, editor settings (Cursor/VS Code), git, shell (zsh + p10k + iTerm), and safe macOS defaults.
- Per-machine directories (`machines/<name>/`) with shared `Brewfile.common` (lastpass + lastpass-cli installed early).
- Non-automatable items reported clearly ("applications that do not support scripted login").
- Interactive review on backup (with `--yes` for non-interactive + summary .md).
- `--dry-run` support (partial), multi-user / no-GitHub friendly (pure file-tree operation).
- Personal profile seeded from current machine (aggressive capture performed).
- All 7 requested tasks completed in order: polished interactive review, README overhaul, prominent no-scripted-login reporting, --dry-run, config dedup, end-to-end tests, VM testing guide.
- Working directly in main project folder `/Users/vupham/Projects/macFoundry`.

**Personal profile snapshot:**
- Brewfile.common (core + many casks from discovery)
- machines/personal/ populated (Brewfile with discovered casks, full configs/, defaults.sh, MANUAL.md)
- LastPass + lastpass-cli early in bootstrap.

> **New agent?** Start with [Agent Handoff](#agent-handoff--start-here) below.

---

## Agent Handoff — START HERE

This section contains everything needed to continue work without prior conversation context.

### 1. What this project does

| Item | Detail |
|------|--------|
| **Purpose** | Capture full machine state (apps, configs, terminal, defaults) into declarative files; reproduce on fresh macOS installs for multiple users/machines |
| **Stack** | Bash (macForge script), Homebrew (Brewfile.common + per-machine), macOS `defaults`, symlink/copy for dotfiles/editors |
| **Repo** | `github.com:vuudoopham/macForge.git` |
| **Working dir** | `/Users/vupham/Projects/macFoundry` |
| **Runtime** | `./macForge backup --machine <name>` and `./macForge apply --machine <name>` (works from plain dir tree) |

### 2. Current state (2026-06-29)

**Machines tracked:**
- `personal` (current user's daily driver — aggressively captured)

**Key artifacts:**
- `Brewfile.common` — shared packages (includes early LastPass + lastpass-cli)
- `machines/personal/Brewfile` + `configs/` + `defaults.sh` + `MANUAL.md`
- `data/apps-requiring-login.txt` — curated list for reporting
- `scripts/macos-defaults.sh` — common curated defaults
- `docs/TESTING.md` — host + Parallels VM guidance

**Active profile:** personal (configs for zsh/p10k, iTerm, Cursor, VS Code, git; discovered casks like brave-browser, iterm2, cursor, aldente, moom, stats, expressvpn, lastpass, etc.)

### 3. Repository layout

```
macFoundry/
├── macForge                     # ★ Main CLI (apply / backup subcommands)
├── Brewfile.common              # Shared packages for all machines
├── machines/
│   ├── personal/
│   │   ├── Brewfile             # Machine-specific additions
│   │   ├── configs/             # zsh/, cursor/, vscode/, git/, etc.
│   │   ├── defaults.sh          # Autocaptured safe macOS defaults
│   │   └── MANUAL.md            # Non-automatable items
│   └── <other-machine>/
├── common/
│   └── configs/                 # Optional shared base configs
├── scripts/
│   └── macos-defaults.sh
├── data/
│   └── apps-requiring-login.txt
├── docs/
│   └── TESTING.md
├── README.md
└── install                      # Legacy thin wrapper for "personal"
```

### 4. How backup/apply works (data flow)

**Backup (aggressive capture):**
```
Scan /Applications + ~/Applications + dotfiles + editors
    → map .app → cask (builtin map + brew heuristics)
    → copy configs (aggressive on contents)
    → autocapture safe defaults
    → write machines/<name>/{Brewfile, configs/, defaults.sh, MANUAL.md}
    → interactive review (or --yes + summary.md)
```

**Apply (reproduce):**
```
xcode + homebrew
early core (lastpass + lastpass-cli)
prompt for LastPass login
brew bundle common + machine
restore configs (common then machine)
apply defaults + machine overrides
print "no scripted login" list
```

### 5. Configuration reference

| Thing | Location | Notes |
|-------|----------|-------|
| Tool entry | `./macForge` | Subcommands: `apply`, `backup` |
| Common packages | `Brewfile.common` | Lastpass early in "Core / Bootstrap" |
| Per-machine | `machines/<name>/Brewfile` | Additional casks |
| Configs | `machines/<name>/configs/` + `common/configs/` | zsh/, editors, git, etc. (per-machine wins) |
| Safe defaults | `machines/<name>/defaults.sh` | Sourced after main script |
| No-login list | `data/apps-requiring-login.txt` | Used by apply report |
| macOS defaults | `scripts/macos-defaults.sh` | Curated, shared |

### 6. Profile / Machine system

Each machine is a self-contained profile under `machines/<name>/`.

- `backup --machine foo` populates `machines/foo/`
- `apply --machine foo` uses `Brewfile.common` + `machines/foo/Brewfile` + layered configs
- Easy to add new users: just run backup on their machine with a new name.

Supports users without GitHub (copy the tree; apply works locally).

### 7. Operational runbook

**Backup a machine:**
```bash
./macForge backup --machine personal
# or non-interactive
./macForge backup --machine personal --yes --commit
```

**Apply on target:**
```bash
./macForge apply --machine personal
# or --yes to skip LastPass wait (not recommended)
```

**Check status:**
```bash
./macForge --help
ls machines/
cat machines/personal/MANUAL.md
```

**Add discovered casks manually (if needed):**
Edit `machines/<name>/Brewfile` or run backup again.

### 8. Output per machine

After apply:
- Apps via Homebrew (common + machine)
- Shell: ~/.zshrc, ~/.p10k.zsh, iTerm prefs if present
- Editors: Cursor/VSCode settings + extensions.txt (manual install step noted)
- Git config
- macOS defaults applied
- Clear "no scripted login" report printed + in MANUAL.md

### 9. Critical do's and don'ts

| ✅ DO | ❌ DON'T |
|-------|----------|
| Use `--machine <name>` consistently | Mix configs across machines |
| Run `backup` after major changes on a machine | Forget to review/commit after backup |
| Keep lastpass + lastpass-cli early | Install heavy licensed apps without documenting in MANUAL |
| Support plain file copies for non-GitHub users | Assume Git is required for apply |
| Update this PROJECT_CONTEXT.md on decisions | Commit secrets or per-machine private data |
| Test with `--dry-run` where possible | Run full apply on production without review |

### 10. Monitoring & debugging

- Check `machines/<name>/MANUAL.md` for manual steps
- After apply: "Applications that do not support scripted login" section
- Re-run `apply` is idempotent (safe)
- Use `--dry-run` to preview
- Configs restored via copy (not always symlinks for portability)

### 11. Development & testing workflow

```bash
# Test backup
./macForge backup --machine test-profile --yes

# Inspect
ls machines/test-profile/
cat machines/test-profile/MANUAL.md

# Test apply (use a temp HOME or careful)
./macForge apply --machine personal --dry-run
```

See `docs/TESTING.md` for host + Parallels VM guidance.

### 12. Key architecture decisions

- Per-machine directories (chosen over heavy layering for simplicity and multi-user sharing)
- Aggressive discovery on backup (with human review gate via interactive or --yes summary)
- Early LastPass in every profile
- Pure Bash + Homebrew (no new languages)
- File-tree only operation (Git optional for distribution)

### 13. Future / Planned

- More robust per-section interactive review UI
- Expanded safe defaults autocapture
- Better --dry-run coverage
- VM-based clean test harness (using Parallels)
- Support for App Store (`mas`) and manual-download apps
- Templating or common layer improvements if duplication grows

---

## Agent Instructions (summary)

1. Always start in `/Users/vupham/Projects/macFoundry`
2. Read this PROJECT_CONTEXT.md (especially Agent Handoff and Current Focus)
3. Check `ls machines/`, `./macForge --help`, recent changes
4. For new machines: run backup with new name, review, commit
5. Always update this file after significant work or decisions
6. Prefer per-machine isolation; keep common things in Brewfile.common / common/configs
7. Never assume a small test = safe for full apply on someone else's machine
8. The "no scripted login" report is a first-class feature — keep the data file updated

## Bootstrap for a New Agent

1. `cd /Users/vupham/Projects/macFoundry`
2. `./macForge --help`
3. `ls -R machines/`
4. Read README.md + this file
5. To continue development: follow the 7-task list or current open items in conversation history
6. To add support for a new user/machine: have them run `backup --machine <their-name>` on their Mac

Update this document after every major change or handoff.
# Install & project init — Linux, macOS, Windows

Codex Flow is a **Unix/Bash** toolkit (Python 3.11+ + Git + Bash). Supported
hosts:

| Host | Support | Notes |
|------|---------|--------|
| **Linux** | First-class | Native `bash install.sh` / `bash scripts/init.sh` |
| **macOS** | Supported | Same commands; Homebrew recommended |
| **Windows** | **WSL2 only** | Native PowerShell/cmd is not supported; use `install.ps1` to forward into WSL |

Delivery scripts also use `gh`/`glab`, `jq`, and each project's test runner.
Optional: Telegram/OpenWA notify, Playwright/Chrome for diagram PDF pipelines.

## Safe first-time sequence (Linux / macOS / WSL)

```bash
git clone https://github.com/pereirawe/codex-flow.git
cd codex-flow
bash install.sh --check          # preflight (platform, python, git, bash, symlinks)
bash install.sh
python3 scripts/restore-vendors.py
cp .codex/telegram.env.example .codex/telegram.env   # fill credentials
python3 scripts/validate.py && python3 scripts/tests/test_flowctl.py
bash scripts/init.sh /path/to/project pt             # locale required for clarity
```

Defaults after install:

- Library link: `~/.codex/flow` → this checkout (symlink)
- Skills: `~/.codex/skills` (override with `--skills-dir`)
- Cursor mirror: `~/.cursor/skills` when `~/.cursor` exists
- Agents: `~/.codex/agents/*.toml`

After **moving** the checkout, re-run `bash install.sh` (symlinks are absolute).

## Linux

```bash
# Debian/Ubuntu example deps
sudo apt update
sudo apt install -y python3 git bash jq
# Optional for GitHub/GitLab delivery:
#   gh / glab
bash install.sh --check && bash install.sh
```

`aibot-watcher` systemd units require `systemctl --user` (optional; install
warns when missing).

## macOS

```bash
# Xcode CLT or Homebrew git/python
brew install python@3.12 git bash jq
# Optional concurrency helper (otherwise lib-os.sh uses mkdir locks):
#   brew install flock
bash install.sh --check && bash install.sh
```

Notes:

- Prefer Homebrew `bash` 5.x if `/bin/bash` is ancient (3.2).
- Issue tracker locks work without `flock` via `scripts/lib-os.sh` (mkdir lock).
- Timestamp math in `close_issue.sh` uses Python (`flow_epoch`), not GNU `date -d`.

## Windows (WSL2)

Native Windows is **rejected** by `install --check`. Supported path:

1. Install WSL2 + Ubuntu: `wsl --install -d Ubuntu` (Admin PowerShell), reboot.
2. Inside the Ubuntu terminal, clone the repo **on the Linux filesystem**
   (e.g. `~/src/codex-flow`), not under `/mnt/c/...` if you can avoid it
   (performance + executable bits).
3. Run the Linux sequence above.

From PowerShell in the repo (forwards into WSL when available):

```powershell
.\install.ps1 --check
.\install.ps1
```

If WSL is missing, `install.ps1` prints setup steps and exits `2`.

### Cursor / Codex on Windows

- Run Codex CLI and Cursor against projects inside WSL, or ensure the Flow
  install lives where the agent can resolve `~/.codex/flow` (WSL home).
- Symlinks require a real Linux environment — Developer Mode alone is not
  enough for this project's Bash pipeline.

## Project init

```bash
bash ~/.codex/flow/scripts/init.sh /path/to/project <locale>
# locale examples: pt | en | es
```

Creates/migrates `.codex/` (issues tracker, `resolved_issues.md`, gitignore with
`sessions/` + `metrics/`, AGENTS managed blocks). Idempotent; existing trackers
are not overwritten.

Hybrid parallel tracker (optional):

```bash
bash ~/.codex/flow/scripts/issues-migrate.sh --keep-monolith
```

## Preflight reference (`install --check`)

Checks:

- Platform (linux / macos / wsl / windows)
- Python ≥ 3.11, git, bash
- Symlink create/resolve
- Vendor skill count (WARN if 0)
- `telegram.env` presence (WARN)
- Existing `~/.codex/flow` / skill / agent symlink health
- Optional: `systemctl` on Linux/WSL

Exit `0` when no hard errors; warnings go to stderr but do not fail the check
unless listed as `ERROR`.

## Portability helpers

| Helper | File | Purpose |
|--------|------|---------|
| `flow_lock_begin` / `flow_lock_end` | `scripts/lib-os.sh` | `flock` or mkdir lock |
| `flow_epoch` | `scripts/lib-os.sh` | UTC epoch from ISO dates |
| `flow_realpath` | `scripts/lib-os.sh` | `realpath` or Python |

Issue mutation scripts (`append-issue`, `transition`, `promote`, `create_issue`,
`close_issue`, `issues-migrate`) source `lib-os.sh`.

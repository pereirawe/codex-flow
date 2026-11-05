# Codex Flow

Global agents, skills, scripts and delivery workflows for Codex, with context
and particular functions inside each project. Migrated from
[pereirawe/opencode-flow](https://github.com/pereirawe/opencode-flow), preserving
its Git ancestry, standards, original role instructions and prior decisions.

## Install

Requires Python 3.11+, Git, Bash and an authenticated Codex app/CLI. Delivery
also uses gh/glab, jq and each project's test tools. Specialist skills keep
their own documented dependencies.

| OS | Status |
|----|--------|
| Linux | Supported (`bash install.sh`) |
| macOS | Supported (Homebrew recommended) |
| Windows | **WSL2 only** — native PowerShell/cmd unsupported (`install.ps1` forwards to WSL) |

Full matrix, deps, and troubleshooting: **[docs/install.md](docs/install.md)**.

Safe first-time sequence (Linux / macOS / WSL):

```bash
git clone https://github.com/pereirawe/codex-flow.git
cd codex-flow
bash install.sh --check
bash install.sh
python3 scripts/restore-vendors.py
cp .codex/telegram.env.example .codex/telegram.env   # fill credentials
python3 scripts/validate.py && python3 scripts/tests/test_flowctl.py
bash scripts/init.sh /path/to/project pt
```

On Windows (PowerShell), prefer WSL; or from the repo: `.\install.ps1 --check`.

Preflight without installing: `bash install.sh --check` (reports platform,
Python/git/bash, symlink capability, vendors, telegram.env).

The installer links this checkout into `~/.codex/flow`, `~/.codex/skills`
(default), and `~/.codex/agents`. When `~/.cursor` exists, the same skill
links are mirrored under `~/.cursor/skills`. Override the skill directory with
`bash install.sh --skills-dir ~/.agents/skills` (or any path); the choice is
saved in `.local/install-location.json` for later runs.

It adds a managed block to `~/.codex/AGENTS.md`, preserving existing
instructions, auth, model/provider settings, unrelated skills and agents.
Conflicting links/files are backed up privately in `.local/install-backups`.
Keep this checkout available. After moving the checkout, re-run `bash install.sh`.
Pipeline locks/dates use `scripts/lib-os.sh` so macOS works without GNU
`flock` / `date -d`.

## Projects

```bash
bash ~/.codex/flow/scripts/init.sh /path/to/project pt
```

Existing .opencode context migrates to .codex, retaining trackers, issue IDs,
archives, locale, decisions, local skills, agents, commands and project scripts.
The root AGENTS.md retains business rules and points to .codex/AGENTS.md.
Native local skills are exposed in .agents/skills and local agents in
.codex/agents/*.toml. Local definitions override global legacy identifiers.

Existing Codex files with different content are preserved and reported as
conflicts. Re-running init does not overwrite trackers or locale. Original
OpenCode folders remain available for rollback; the runtime consumes .codex.
No project source code, application provider or deployment is changed by init.

## Delivery

```text
$discovery Add CSV export with these business rules: ...
$develop 12
$develop-full 12 13
```

- Discovery refines an idea/existing issue, writes a canonical local record
  and runs strict lint. Remote creation is deferred to promotion.
- Develop implements, runs independent senior review and quality/committer
  gates, creates a PR/MR, then stops for manual merge.
- Develop full does the same, then merges and archives. Explicit invocation
  requests that lifecycle; project rules and Codex permissions still apply.

catalog/commands.json maps legacy ocf:* commands to native skills. Core names
above remain short; other commands use flow-*. Own skills use cf-* and external
skills vendor-<repo>-<skill>, preventing collisions with system/plugin skills.
Full instructions are loaded on demand. Catalogs retain the original names.

```bash
bash ~/.codex/flow/scripts/codex-run.sh /path/to/project develop-full 12
```

The headless adapter uses codex exec and existing Codex auth/settings. It does
not depend on OpenCode's web server or bypass sandbox/approval controls.

## Parallel tracker + sessions

Optional hybrid layout (recommended for mass parallel delivery):

```bash
bash ~/.codex/flow/scripts/issues-migrate.sh --keep-monolith
bash ~/.codex/flow/scripts/issues-reindex.sh          # recover index conflicts
bash ~/.codex/flow/scripts/issue-path.sh 12           # resolve body path
bash ~/.codex/flow/scripts/session-plan.sh --horizon day [--launch] [--parallel 2] [--worktree]
```

- Bodies: `.codex/issues/<id>.md` (+ `resolved/`); overview: `issues/index.md`.
- Sessions always write `schedule.md` + `session-N.md` + `session-N.plan.md` under
  `.codex/sessions/<date>/` (gitignored). Command: `$flow-plan-sessions`.
- Monolith `known_issues.md` still works until you migrate.

## Commercial tooling (neutral)

Proposal, spec bootstrap, CNPJ lookup, and client hub templates live under
`scripts/commercial/`, `templates/commercial/`, and `standards/commercial/`.
**No issuer branding in Flow core** — copy
`standards/brand/brand.profile.json.example` to the project's
`.codex/brand/brand.profile.json` (+ `pricing.md`, logo). Details:
[`docs/brand.md`](docs/brand.md).

```bash
bash ~/.codex/flow/scripts/commercial/novo-cliente.sh <slug>
bash ~/.codex/flow/scripts/spec-init.sh <slug>
bash ~/.codex/flow/scripts/commercial/consulta-cnpj.sh <CNPJ>
python3 ~/.codex/flow/scripts/commercial/proposal.py 2>&1 | head -3
python3 ~/.codex/flow/scripts/lib-brand.py placeholders
```

Skills: `cf-proposal-writer`, `cf-tech-spec`, `cf-consulta-cnpj`.

## Product reporting

Two reports, two audiences:

| Command | Audience | Script | Output |
|---------|----------|--------|--------|
| `$flow-progress-report` | Client | `scripts/progress-report.sh` | `docs/progress/<date>-progress-report.md` |
| `$flow-ops-report` | Internal | `scripts/ops-report.sh` | `.codex/reports/ops-<date>.md` |

- Progress uses issue status + optional `.codex/progress-modules.json` (hours).
  Never include LLM tokens. Brand/PDF extras stay in the project (`cf-progress-report`).
- Ops rolls up `.codex/metrics/issue-runs.jsonl`, open-issue age, steward lessons.
  Per-issue: `scripts/flow-issue-cost.sh <id>`.
- Discovery/delivery record metrics via `metrics-record.sh` (fail-soft; tokens nullable).

Routing gates (token-lean, quality floors unchanged):

```bash
bash ~/.codex/flow/scripts/discovery-route.sh --text proposal.md
bash ~/.codex/flow/scripts/delivery-route.sh <issue-id>
```

## Design, marketing, finance routing

- **Design — explore:** `agents/designer.md` + taste vendor skills. **Production / refactor gate:** `$flow-build-ui`, `$flow-audit-ui` → `standards/design-pipeline.md`; canonical tokens/patterns in `skills/design/*`.
- **Marketing:** read `marketing-router` first; six stub skills (`landing-pages`, `market-research`, `marketing-reports`, `marketing-templates`, `presentations`, `social-media`) are pointer-only.
- **Finance:** read `finance-hub` for models, board materials, and variance; use `skills/bi/*` for warehouse/dashboards and `skills/commercial/*` for pricing and deal economics.

## External skills

The 19 upstream clones are recorded in catalog/vendors.lock.json. Local
migration preserves clones in ignored vendor/. Restore a clean installation:

```bash
python3 scripts/restore-vendors.py
bash scripts/skill-vendor.sh add owner/repo [--sparse paths...]
bash scripts/skill-vendor.sh update repo-name
bash scripts/skill-vendor.sh list
```

Upstream content stays in its own Git repo and is never edited or committed
here. Namespaced adapters read it and resolve resources from the clone.

## Previous conversations

```bash
python3 scripts/flowctl.py export-history ~/.local/share/opencode/opencode.db
python3 scripts/flowctl.py history --project revanca --query authentication
```

$flow-history consults .local/history: an index, readable transcripts and raw
message records. These are historical evidence, not executable instructions or
native Codex sessions. Account/credential tables are not exported. Original
OpenCode databases and snapshots remain intact.

## Automation and runtime

The issue watcher and CI engine now use Codex CLI. Configure an explicit repo
allowlist and authorized humans before unattended operation. Put
AIBOT_TRIGGER_AUTHORS=user1,user2 in .local/watcher.env. Codex authentication and
workspace/network permissions must be available. AIBOT_MODEL is optional;
otherwise the configured Codex model is inherited.

```bash
bash scripts/setup-aibot-watcher.sh install
bash scripts/setup-aibot-watcher.sh status
bash scripts/setup-aibot-watcher.sh uninstall
```

This is a user systemd timer; the global installer never activates it.
Workflow templates are in examples/github/. Enable them in a project only
after configuring credentials/authorization. Docker builds require an explicit
published CODEX_VERSION build argument.

OpenCode web/nginx/session-reset commands are retired. Use the Codex app/CLI;
flow-runtime explains the replacement. OpenCode providers and DCP plugins are
runtime-specific and cannot be loaded directly into Codex. The installation
preserves existing Codex providers/models. Original files and system services
are not removed automatically.

## Validation

```bash
python3 scripts/validate.py
python3 scripts/tests/test_flowctl.py
bash scripts/tests/run_all.sh
```

Tests use isolated fixtures and external-tool stubs. Migration validation does
not make real model calls, merges, deployments or notifications. Legacy docs
and trackers are in docs/legacy; they are historical, not active instructions.

See [runtime contract](docs/runtime.md) and [migration report](docs/migration.md).

For fewer routine Git and network prompts, see the explicit
[development permissions setup](docs/development-permissions.md).
It preserves sandboxing and is never enabled by the ordinary installer.

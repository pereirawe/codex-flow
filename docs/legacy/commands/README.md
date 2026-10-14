# Slash Commands

These commands are available in the assistant.

| Command | Purpose |
|---------|---------|
| `$flow-$flow-init` | Initialize `.codex/` project config with repo context |
| `$flow-scan-issues` | Deep codebase analysis; detect and register new issues |
| `$flow-review-branch` | Full PR/MR-style code review |
| `$flow-plan-feature` | Feature breakdown with risk assessment |
| `$flow-promote <id>` | Promote backlog item to open + create remote issue |
| `$develop [id...]` | Run the full task lifecycle up to MR creation for one or more issues (promote → develop → review → QA → MR → wait for manual merge) |
| `$develop-full [id...]` | Run the full task lifecycle end-to-end for one or more issues (promote → develop → review → QA → MR → auto-merge → archive) |
| `$flow-commit` | Create structured commit with `Status:` trailers |
| `$flow-sync-issues` | Sync known_issues with remote issue tracker |
| `$flow-archive-issue <id>` | Archive resolved issue to compact format |
| `$flow-check-pr [id]` | Check PR merge status and auto-archive merged |
| `$flow-maintain` | Full maintenance of known_issues.md |
| `$flow-backup` | Create intelligent timestamped backup excluding junk |
| `$flow-build-ui` | Orchestrate the 4-pass greenfield design pipeline (art-director → ui-architect → ui-implementer → ui-critic) with deterministic output files |
| `$flow-audit-ui` | Orchestrate the audit/refactor pipeline for existing codebases (ui-auditor → ui-refactor-planner, optionally → build pipeline) |
| `$flow-bump-version` | Calculate version bump, update changelog, commit, tag, and publish to main |
| `$flow-linkedin-carousel <tema> [<direção>]` | Generate a LinkedIn carousel deck (1080×1080 slides → deck.pdf) from a researched topic — runs inside the target project, preflight `person.json`/logo, web research with saved sources, canonical `deck.json` spec, each::sense art + deterministic Chrome typography/logo (prompts-only fallback without the key); outputs under `docs/carousel/<slug>/`; nothing is published |

## Command Definition Rule

Every command has two parts that MUST be kept in sync:

1. **`opencode.json` → `command.<name>.template`** — executable instructions
   for the AI (source of truth, what actually runs)
2. **`commands/<name>.md`** — user-facing documentation

### Rules

- `opencode.json` is the **source of truth** — the template defines the
  executed behavior
- `commands/<name>.md` is the **user-facing documentation** that describes
  the flow, usage, and pre-conditions
- **Both MUST be created/updated together** — whenever a template changes in
  `opencode.json`, the corresponding `.md` must be synced
- The `.md` MUST reflect the flow described in the template, including
  conditional decisions, validations, and pre-conditions

### Checklist for new commands

- [ ] Add entry in `opencode.json` → `command.<name>` with `template` and
      `description`
- [ ] Create `commands/<name>.md` documenting flow, usage, and pre-conditions
- [ ] Add to the table in this `README.md`
- [ ] Verify if the command needs a script in `scripts/`

## Known Issues

Single source of truth for tracked work in this project.

### Format

```markdown
### <id>. <title>

- Status: backlog | ready | open | in-progress | in-review | in-qa | in-publish | resolved
- Opened: <YYYY-MM-DD> | -
- Ready: <YYYY-MM-DD> | -
- Started: <YYYY-MM-DD> | -
- In review: <YYYY-MM-DD> | -
- In QA: <YYYY-MM-DD> | -
- In publish: <YYYY-MM-DD> | -
- Type: bug | feat | doc | chore
- Severity: critical | high | medium | low
- Report: <user-name> | <model-name>
- Base branch: <default-branch> | <branch-name>
- Reviewers: <number> (<profile1>, <profile2>)
- Remote: - | #<remote-id>
- Jira: - | <KEY-N>
- PR: - | #<pr-number>
- Location: <file-path>:<line-numbers>
- Description: <brief>
- Impact: <what or who is affected>
- Business rules: <specific business logic, constraints, and domain rules>
- Acceptance criteria: <what must be true for the issue to be complete>
- Tests: <scenario → outcome lines, defined during discovery>
- Suggested fix: <approach or next step>
```

`Business rules:` is required for `feat` type issues.
`Tests:` is MANDATORY for every new issue, captured during discovery as
`scenario → outcome` lines. For `doc`/`chore` types the literal `- Tests: -`
is permitted (no test surface). For `feat`/`bug` types at least one
`scenario → outcome` line is REQUIRED and the value may NEVER be `-`. Severity
floor: `critical`/`high` → ≥3 lines, `medium` → ≥2, `low` → ≥1; if `Severity`
is missing, the medium floor (≥2) applies. Enforcement is verified by QA
pre-development review (Phase 5) and senior reviewers — NOT enforced by
scripts. Missing or insufficient `Tests:` = `incomplete-spec` (discovery gap),
not a bug.
`Base branch:` is set during discovery (usually `main`/`master`).
`Reviewers:` stores count and profiles (set during discovery, e.g. `1 (backend)`).
`Remote:` is populated automatically during promotion, after local discovery.
`Jira:` is optional (default `-`) — the Jira Cloud card key (e.g. `DEV-123`)
mirrored from this issue when the Jira sync is enabled (issue #48), separate
from `Remote:`. Populated by `scripts/sync-jira.sh` (hooks in
create_issue.sh/promote.sh/close_issue.sh or the `ocf:sync-jira` command);
non-blocking, local `Status:` always wins.
`Opened:`/`Ready:`/`Started:`/`In review:`/`In QA:`/`In publish:` lifecycle
timestamps are stamped by the pipeline scripts (create_issue.sh on remote
creation success; promote.sh on backlog→ready and ready→in-progress;
transition.sh on in-progress→in-review→in-qa→in-publish; close_issue.sh stamps
`Resolved:` and computes `Durations:` into the archive — per-stage components
backlog/waiting/dev/review/qa/publish/total). Set-if-absent, idempotent, new
issues only. See `standards/issues.md` for the full contract.


### 1. Migrate global OpenCode workflows and project context to Codex
- Status: in-progress
- Type: feat
- Severity: high
- Priority: high

- Report: Codex
- Base branch: main
- Reviewers: 2 (security, devops)
- Remote: -
- Jira: -
- PR: -
- Location: -
- Description: Preserve the global workflow library and local project extensions while using native Codex skills and agents.
- Impact: 
- Business rules: Global definitions stay global; project context and overrides stay local. Preserve issue IDs and history. Keep credentials and exported chats private.
- Acceptance criteria: Native manifests validate. Installation preserves existing Codex settings. Project migration preserves trackers and extensions. Public package excludes private data.
- Tests: Repeat installation -> existing model/auth/settings remain intact.
Migrate and move a project -> issues and local skill links remain readable.
Untrusted multiline comment -> cannot authorize its author.
- Suggested fix: -

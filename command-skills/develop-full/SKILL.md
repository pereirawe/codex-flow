---
name: develop-full
description: 'Run the full task lifecycle end-to-end for one or more issues: promote,
  develop, review, QA, MR, auto-merge, return-to-base, close + archive'
---

## Codex runtime contract

This workflow was migrated to Codex. Read `~/.codex/flow/docs/runtime.md`
before its first use. Resolve scripts from `~/.codex/flow/scripts/` and run
them with CWD set to the intended project. Read the project's root AGENTS.md,
then `.codex/AGENTS.md` and relevant local context. Project definitions take
precedence over global definitions with the same legacy identifier.

Legacy `Task(role)` means a Codex subagent using the role in the agent catalog;
if that role cannot be selected natively, read its instructions and include
them in the subagent task. Never run OpenCode. Legacy read/glob/grep/skill
names mean the equivalent available Codex file/search/skill tools. Read a
referenced skill by resolving its legacy name in `catalog/skills.json`.
Shell snippets using OpenCode's !`...` notation are examples, not executable
directives: run the corresponding reviewed command with native shell tools.

Inherit Codex permissions and model settings. Old permission YAML is source
metadata, not an enforcement mechanism. Stop on failed gates; never claim
unperformed tests/reviews passed. Only send external notifications/comments
when the user explicitly invokes a workflow that includes them or separately
authorizes them. Mere migration, file reading, or implicit skill selection
does not authorize sending. Do not hide approval rejections from the user.

## $develop-full [id...]


Run the ENTIRE task flow for one or more tracked issues, from promotion to
archived merge, automatically — no confirmation, no permission prompts, no
pausing. After the MR is created the pipeline **auto-merges**, returns to the
base branch, and closes/archives the issue.

**Design:** this command drives the pipeline directly. There is NO
orchestrator agent in the critical path — `scripts/detect-lang.sh` picks the
dev agent, and the merge/close is `scripts/merge-and-close.sh`. Agents appear
only where judgment is needed: the **developer** (implementation) and the
**senior reviewers** (parallel domain review). This cuts the old 6+N agent
chain to 1+N and removes mechanical roundtrips.

At least ONE issue ID is required. Multiple IDs may be separated by spaces,
commas, or dashes; deduplicated (order preserved), processed sequentially. A
single Telegram notification is sent after the LAST issue via
`scripts/flow-notify.sh` (credentials in `.codex/telegram.env`).

### Arguments

```
$develop-full 4
$develop-full 4 5 6
$develop-full 4,5,6
$develop-full #4 #5 #6
```

### Auto-Promotion Flow (silent)

Missing data handled gracefully: `Base branch:` → git default; `Reviewers:` →
`1 (backend)`; `Remote:` → auto-created via `create_issue.sh` if missing.

| Status | Action |
|--------|--------|
| `backlog` | `promote.sh` → `ready`; if `Remote: -`, `create_issue.sh`; `promote.sh` → `in-progress` + branch |
| `ready` | if `Remote: -` → `create_issue.sh`; `promote.sh` → `in-progress` + branch |
| `open` w/ Remote | `in-progress` + branch `issue-<id>-<slug>` |
| `open` w/ `Remote: -` | `create_issue.sh` → `in-progress` + branch |
| `in-progress` | proceed |
| `in-review`/`in-qa`/`in-publish`/`resolved` | Refuse — past development |

### Full Task Flow (per issue)

1. **Resolve `known_issues.md`** (project `.codex/` first, global fallback).
2. **Fill gaps**: detect `Base branch:` from git if empty, default `Reviewers:`
   to `1 (backend)`, auto-create `Remote:` if needed — no user prompts.
3. **Promote**: run the flow above (`create_issue.sh` + `promote.sh`).
4. **Warm current issue**: `scripts/preflight.sh <id>` builds the file
   inventory so the developer skips re-exploration.
5. **Pick dev agent**: prefer `delivery-route.sh` → `dev_agent`, or
   `LANG=$(scripts/detect-lang.sh [location])` →
   `development/devs/golang` | `development/devs/python` | `development/developer`.
   If every `Location:` file is `.ts` or `.tsx`, use `development/developer`
   even when detect-lang prints python (`src/` is scored as Python).
6. **Implement**: `Task(<devagent>)` — implement per business rules, write
   tests via `test-runner` skill, self-review, `transition.sh <id> in-review`.
   No pausing. Record `metrics-record.sh --issue <id> --flow develop-full --step implement`.
7. **Route reviewers**:

```bash
bash ~/.codex/flow/scripts/delivery-route.sh <id>
```

   Launch Tasks only for `reviewers_to_run`. Skipped = no domain files (script
   attest). Floor/security already enforced. `review-preflight.sh` is invoked
   by the router for each profile.
8. **Parallel senior review**: one `Task(development/senior-reviewers/<profile>)`
   per `reviewers_to_run` entry in a **single** message. All must approve.
   On issues → `Task(<devagent>)` fixes, then re-review — at most
   **`max_rereview_cycles` (2)**; then STOP + notify.
9. **Quality + committer gate**: after the last tracker edit, run
   `test-runner.sh --run` then `committer-check.sh <id>`. Must PASS before any
   `in-publish` transition (never set in-publish on FAIL). On FAIL → STOP.
   Record `metrics-record.sh --issue <id> --flow develop-full --step committer`.
10. **Create MR**: `git push -u origin HEAD` first (create-pr does not push),
    then `scripts/create-pr.sh <id>` (sets `- PR: #<n>` only — never a full URL).
11. **Merge + archive**: commit+push tracker `- PR: #<n>`, then
    `OCF_CLOSE_COMMENT=1 scripts/merge-and-close.sh <id>` with unrestricted
    network/`gh` (sandbox GraphQL returns Forbidden). Retry once on
    `Base branch was modified`. Empty `- PR: -` → set `#<n>` and
    `close_issue.sh` on base. After squash, hard-reset local base to origin
    if diverged, then archive.
12. **Warm next**: if there is a next ID, `scripts/preflight.sh <next-id>` now
    (clean base) so the next developer starts warm.
13. **Repeat** for the next issue.

### Notify

Exactly ONE `~/.codex/flow/scripts/flow-notify.sh` after the LAST issue:
per-issue summary (id, PR link, merged). Telegram first, then OpenWA; non-zero
when both fail. No intermediate notifications. Subagents never notify.

### Failure Handling

Any failure (not found, refused status, review not approved, committer gate
FAIL, MR/merge fails) → STOP the list, send ONE failure notification. Already
merged issues stay resolved; the failed issue keeps its current status.
On success or stop, this agent reads
`~/.codex/flow/skills/shared/flow-steward/SKILL.md` and runs it once for
`develop-full`.

### Loop profiles

Discovery selects the loop; delivery is the same engine, differentiated by
reviewer count + auto-merge. See `workflow.md` § Loop Profiles:
`feat-full` (PO+TL, full depth), `bug-expedite` (critical/high, 2 reviewers +
security, high quality bar), `bug-lean` (low/medium, 1 reviewer, fast),
`chore` (light). Bugs trade depth for speed but keep a higher quality bar.


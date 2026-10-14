---
name: develop
description: 'Run the full task lifecycle up to MR creation for one or more issues:
  promote, develop, review, QA, MR — then wait for a manual merge (no auto-merge,
  no archive)'
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

## $develop [id...]


Run the task flow for one or more tracked issues, from promotion to **MR
creation**, automatically. No confirmation, no pausing. The command **stops
after the MR is created**: it does NOT merge, does NOT close/archive. The MR is
left OPEN for a human review/merge.

**Design:** same flattened engine as `$develop-full` — the pipeline runs
directly via scripts, with no orchestrator agent. `scripts/detect-lang.sh` picks
the dev agent; agents appear only for judgment (developer + parallel senior
reviewers). Mechanical steps (promote, preflight, committer gate, create-pr) are
scripts.

At least ONE issue ID required. Multiple IDs separated by spaces/commas/dashes;
deduplicated, processed sequentially. One Telegram notification after the LAST.

### Arguments

```
$develop 4
$develop 4 5 6
$develop #4 #5 #6
```

### Auto-Promotion Flow (silent)

`Base branch:` → git default; `Reviewers:` → `1 (backend)`; `Remote:` →
auto-created via `create_issue.sh` if missing.

| Status | Action |
|--------|--------|
| `backlog` | `promote.sh` → `ready`; `create_issue.sh` if needed; `promote.sh` → `in-progress` + branch |
| `ready` | `create_issue.sh` if needed; `promote.sh` → `in-progress` + branch |
| `open` w/ Remote | `in-progress` + branch |
| `in-progress` | proceed |
| `in-review`/`in-qa`/`in-publish`/`resolved` | Refuse — past development |

### Task Flow (per issue, up to MR)

1. **Resolve `known_issues.md`** (project first, global fallback).
2. **Fill gaps** (base/reviewers/remote) — no prompts.
3. **Promote**: `create_issue.sh` + `promote.sh`.
4. **Warm current**: `scripts/preflight.sh <id>`.
5. **Pick dev agent**: `LANG=$(scripts/detect-lang.sh [location])`.
6. **Implement**: `Task(<devagent>)` → tests → self-review → `transition.sh <id> in-review`.
7. **Review preflight (per profile)**: read `- Reviewers:` (`<n> (profiles)`).
   For EACH profile, run `scripts/review-preflight.sh <id> <profile>` — a fast
   sequential loop of N calls that writes
   `.codex/preflight/review-<id>-<profile>.md` (scoped, profile-filtered
   context for the reviewer). Only then dispatch the reviewers (next step).
8. **Parallel senior review**: one `Task(development/senior-reviewers/<profile>)`
   per profile, in a single message. All approve; else fix+re-review loop.
9. **Gate**: `scripts/committer-check.sh <id>` → PASS ⇒ `transition.sh <id>
   in-publish`. FAIL ⇒ STOP + notify.
10. **Create MR**: `scripts/create-pr.sh <id>` (sets `- PR: #<n>`).
11. **Report "esperando merge manual"**: do NOT merge/close. Issue stays
    `in-publish`, MR OPEN.
12. **Return to base**: `git checkout <base>` + `git pull` (base has no change).
13. **Repeat** for the next issue.

Closing/archiving after manual merge: `$flow-check-pr <id>` (or Close Requester).

### Telegram & Failure

One notification after the LAST issue. Any failure → STOP list, one failure
notification. Delivered issues stay `in-publish` with MR open.


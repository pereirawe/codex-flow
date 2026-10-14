---
name: flow-promote
description: Promote an issue — backlog→ready or ready→in-progress with branch
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

## $flow-promote <id>


Promote a tracked issue in `known_issues.md` to the next lifecycle stage.
Data is read from the issue entry. Missing fields are handled gracefully:
`Base branch:` detected from git, `Reviewers:` defaults to 1,
`Remote:` auto-created if missing — no user prompts.

### Flow

| Current Status | Action |
|----------------|--------|
| `backlog` | `promote.sh <id>` → `ready` (status only, no branch) |
| `ready` | Auto-create remote if missing, then `promote.sh <id>` → `in-progress` + branch `issue-<id>-<slug>` |
| other | Refuse — issue cannot be promoted from its current status |

The script handles: base branch checkout/pull, feature branch creation,
reviewer profile validation, remote creation if needed, and status update.

### Status lifecycle

| Status | Description |
|--------|-------------|
| `backlog` / `ready` | Planning states — can be promoted |
| `in-progress` | Remote issue exists, work has started |
| `in-review` | Senior review completed, awaiting QA |
| `in-qa` | QA verifying post-review corrections |
| `in-publish` | Committer gate passed, MR created, awaiting merge |
| `resolved` | Terminal state — issue moved to archive |

### Usage

```
$flow-promote 2
```


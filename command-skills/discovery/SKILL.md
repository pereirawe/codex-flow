---
name: discovery
description: Refine an idea or existing issue into a canonical, linted local issue.
  Use for discovery before delivery.
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

## $discovery [proposal | id]


Transform a raw idea (free text) or an existing issue id into a tracked, typed,
linted issue. Discovery is the ONLY phase with user interaction — give the
business context in the argument; the agent does not prompt mid-flow.

Bugs and feats use **different loops** (see `workflow.md` § Loop Profiles):
bugs resolve faster (fewer agents) with a higher quality bar; feats keep full
depth (PO + TL). All loops end with `scripts/append-issue.sh` + `issue-lint.sh`.

### Arguments

```
$discovery "Add CSV export to reports screen"
$discovery 12          # refine an existing backlog/ready issue
$discovery "Bug: login fails when token expires"
```

### Flow

1. **Resolve `known_issues.md`** (project `.codex/` first, global fallback).
2. **Classify**: if argument is a number and the issue exists, refine it;
   otherwise treat as a new proposal. Infer `- Type:` (`bug` if it reads like a
   defect/regression, else `feat`) and `- Severity:` when stated.
3. **Run the discovery subagent**: `Task(development/discovery)` with the
   proposal/context. It selects the loop, runs PO/TL as needed, calls
   `scripts/append-issue.sh` (canonical entry) and `scripts/issue-lint.sh
   --strict`, and reports the created `id`.
4. **Verify**: re-run `scripts/issue-lint.sh <id>` on the result; if it fails,
   report the gaps (do not auto-fix — discovery already attempted).
5. **One Telegram notification** with the outcome (id, type, loop, lint status,
   `known_issues.md` link).

### Notes

- No PM agent, no remote question — `Remote:` is auto-created at promotion
  (`$develop` / `$develop-full`).
- For `feat`, include business rules + acceptance in the argument when possible
  to skip a refinement cycle.
- After discovery, hand off with `$develop-full <id>` (end-to-end) or
  `$develop <id>` (manual merge).


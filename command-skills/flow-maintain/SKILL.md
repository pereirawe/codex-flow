---
name: flow-maintain
description: Maintain known_issues.md and prioritization.md
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

## $flow-maintain


Full maintenance of the tracker file `known_issues.md`.

### Flow

1. **Run `maintain.sh`** — detects remote states, reports stale issues
2. **Archive stale resolved issues** — for each remote-closed issue, run `close_issue.sh <id>`
3. **Reindex if needed** — renumber remaining issues in `known_issues.md`
4. **Report** — summarize what was archived, updated, and skipped

### Detailed steps

#### 1. Check remote states

```bash
$SCRIPTS_DIR/maintain.sh
```

Output:
- Issues with `Remote: #<id>` → checks if remote is open/closed
- Issues with `Remote: -` → local-only, skip
- Reports mismatches (local says `in-progress` but remote is closed)

#### 2. Archive resolved

For issues where remote is closed but local is still `in-progress`:

```bash
$SCRIPTS_DIR/close_issue.sh <id>
```

This:
- Closes remote issue (already closed, will no-op)
- Archives to `resolved_issues.md` in compact format
- Removes from `known_issues.md`

#### 3. Reindex

After removals, renumber issues sequentially:

```bash
awk '/^### [0-9]+\./{count++; sub(/^### [0-9]+/, \"### \" count)} 1' known_issues.md > tmp && mv tmp known_issues.md
```

#### 4. Report

Output a summary:
```
[maintain] Known issues: 4 active, 1 archived, 0 stale
```

### Automation notes

- `maintain.sh` is safe to run independently — it only reads remote state and reports, never modifies files
- Actual archiving requires the assistant to run `close_issue.sh` after reviewing the report
- Proposals in `.codex/prioritization.md` (project-level) or
  `~/.codex/flow/prioritization.md` (global fallback) should
  be checked separately for items ready to promote


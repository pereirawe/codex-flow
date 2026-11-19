---
name: flow-progress-report
description: Generate a client-facing progress report (issues + optional hours modules)
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

## $flow-progress-report [--date YYYY-MM-DD]

Client-facing progress report from `known_issues.md` + `resolved_issues.md`.

Optional project file `.codex/progress-modules.json` maps proposal modules →
hours → issue IDs for % by hours. Optional `docs/progress/unmapped-tasks.tsv`
lists out-of-proposal work.

### Flow

1. `cd` to the project root.
2. Run:

```bash
bash ~/.codex/flow/scripts/progress-report.sh [--date YYYY-MM-DD]
```

3. Report path is printed (default `docs/progress/<date>-progress-report.md`).
4. For richer PDF/Gantt/brand, follow `cf-progress-report` (brand assets stay
   in the project — never hardcode a company logo in the Flow core).
5. Do **not** include token/LLM cost (that belongs in `$flow-ops-report`).

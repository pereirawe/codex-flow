---
name: flow-scan-issues
description: Deep codebase analysis and issue detection
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

## $flow-scan-issues


Deep analysis of the codebase to detect and register new issues.

The working directory (`$PWD`) determines the target project. All paths are
relative to the project root, **not** to the global opencode config.

Responsibilities:
- Detect new issues (security, concurrency, architecture, reliability)
- Create (if absent) and update `$PWD/.codex/known_issues.md` (project issue tracker)
- For issues related to opencode config itself, update `$HOME/.codex/flow/known_issues.md` (global issue tracker)
- Follow the issue entry format from `standards/issues.md`
- Normalize `Status`, `Type`, `Severity`, and `Reported by`
- Avoid duplication

Triggers:
- After major changes
- Before PR/MR


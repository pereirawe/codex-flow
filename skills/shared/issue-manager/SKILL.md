---
compatibility: Codex with local shell tools
name: cf-issue-manager
description: Maintain the tracked work register with code-backed evidence and remote
  sync
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

## What I do

- Maintain `.config/opencode/known_issues.md` as the tracked issue register
- Prefer updating existing entries over creating duplicates
- Keep issue descriptions concise, actionable, and backed by code evidence
- Synchronize local issues with remote trackers (GitHub/GitLab)
- Archive resolved issues to `resolved_issues.md`

## What to look for

- Security: input handling, external calls, randomness, secrets
- Concurrency: shared state, race windows, goroutine/thread safety
- Reliability: timeouts, retries, resource cleanup, config drift
- Architecture: mixed concerns, dead code, workflow drift
- Remote drift: local status vs remote issue state mismatch

## Rules

- Do not speculate without code evidence
- Prefer file and line references when possible
- Remove or mark resolved issues when the code already fixes them
- Keep fields normalized:
  - `Status`: `backlog`, `ready`, `open`, `in-progress`, `in-review`, `in-qa`, `in-publish`, `resolved`
  - `Type`: `bug`, `feat`, `doc`, `chore`
  - `Severity`: `critical`, `high`, `medium`, `low`
  - `Reported by`: user name for human-reported items, model name for AI-reported items
- `Remote:` field is mandatory — use `-` when no remote exists
- When resolving an issue, archive it to `resolved_issues.md` in compact format

## Remote sync

- Use `$flow-sync-issues` to synchronize local ↔ remote state
- When promoting (`$flow-promote`), create a remote issue via `create_issue.sh`
- When closing (`$flow-close-issue`), close remote issue and archive
- Prefer `gh` for GitHub, `glab` for GitLab — detect via `git remote -v`

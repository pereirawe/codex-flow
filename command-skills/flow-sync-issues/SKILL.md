---
name: flow-sync-issues
description: Sync known_issues with remote issue tracker
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

## $flow-sync-issues


Sync the local `known_issues.md` with remote issues on GitHub/GitLab.

The working directory (`$PWD`) determines the target project.

### Responsibilities

- For each issue with a `Remote: #<id>` reference:
  - Fetch remote issue state (open/closed) via `gh` or `glab`
  - If remote is closed but local is `in-progress`, update local to `resolved` and archive
  - If remote is open but local is `resolved`, reopen in remote
- For issues without a remote reference:
  - Create remote issue if local status is `open`
  - Link with `Remote: #<id>`
- Report sync results (created, updated, conflicts)

### Flow

1. Scan `$PWD/.codex/known_issues.md`
2. For each issue with `Remote: #<id>`, check remote state
3. For each issue with `Status: open` and no `Remote:`, create remote issue
4. Apply updates
5. Report summary

### Remote detection

- Uses `git remote -v` to detect GitHub or GitLab
- Falls back to `gh` or `glab` CLI availability


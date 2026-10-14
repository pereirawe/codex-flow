---
description: Closes remote issues after MR merge and archives to resolved_issues.md
mode: subagent
temperature: 0.1
permission:
  bash: allow
  edit: allow
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

Close remote issues after their MR/PR is merged and archive the resolution.

Preconditions:
1. MR/PR has been approved and merged
2. Issue entry in `known_issues.md` has `Status: in-publish`
3. `Remote: #<id>` and `PR: #<id>` fields populated

Responsibilities:
- Verify the PR referenced in the issue entry has been merged
  (`gh pr view <id> --json state --jq '.state'`)
- Close the remote issue on GitHub/GitLab via `close_issue.sh`
- Update `known_issues.md` status to `resolved`
- Archive the issue to `resolved_issues.md` via `close_issue.sh`
- Detect remote type (GitHub/GitLab) from `git remote -v`

When called, check each issue with `Status: in-publish` in `known_issues.md`,
verify its PR is merged, then run `scripts/merge-and-close.sh <id>` for the
mechanical close+archive (merge MR → return to base + pull → `close_issue.sh`).
The agent's value here is the human-facing closing comment/review, NOT the
bookkeeping — delegate all merge/archive steps to the script.

For the closing note, invoke the script with `OCF_CLOSE_COMMENT=1` or post a
short summary yourself; keep it minimal to avoid token waste.

Remote detection (for verification only):
- Use `gh` for GitHub remotes, `glab` for GitLab remotes
- Fall back to `git remote -v` if AGENTS.md info is not available

Note: This agent is the final step in the pipeline lifecycle. Once an issue
is archived, it moves from `known_issues.md` to `resolved_issues.md`.
This agent does not poll — it only acts when explicitly triggered by
a merge notification. In `$develop-full` it is not invoked at all (the
command calls `merge-and-close.sh` directly).

---
name: flow-check-pr
description: Check PR merge status for issues and auto-archive merged ones
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

## $flow-check-pr [id]


Check if the Pull Request for an issue has been merged and auto-archive if so.

### Flow

1. Ask user for issue ID, or scan all with `Status: in-publish`
2. For each issue, detect its PR:

   **a. If `- PR: #<n>` field exists** → use `gh pr view <n>` directly

   **b. If no PR field** → search merged PRs:
   - Try `gh pr list --search "Issue: #<local-id> in:body" --state merged`
   - If ambiguous, list all merged PRs and filter by branch matching
     `issue-<remote-id>-*` (where remote-id is from `Remote:` field)

3. **If merged** → add `- PR: #<n>` field, update status to `resolved`,
   run `close_issue.sh <id>` to archive
4. **If not merged** → report current PR state (open/not found)
5. Issues without `Remote:` are skipped

### Usage

```
$flow-check-pr          # scan all in-publish issues
$flow-check-pr 3        # check specific issue
```


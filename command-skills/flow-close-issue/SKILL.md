---
name: flow-close-issue
description: Close remote issue and archive after PR merge
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

## $flow-close-issue [id]


Close a remote issue and archive it after its PR has been merged.

### Flow

1. **Detect issue**: from argument, current branch (`issue-<id>-<slug>`),
   or ask if neither is available
2. **Read issue entry** from `known_issues.md` — requires `Status: in-publish`
   and `Remote: #<id>` populated
3. **Verify PR merged** via `gh pr view <pr-id> --json state --jq '.state'`
   using the `- PR: #<n>` field; if missing, search merged PRs by branch
4. **If merged**: run `scripts/close_issue.sh <id>` which closes the remote
   issue and archives to `resolved_issues.md`
5. **If not merged**: report PR state and abort

### Usage

```
$flow-close-issue
$flow-close-issue 4
```


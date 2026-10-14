---
name: flow-aibot-notify
description: Post standardized aibot message to a remote issue
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

Post exactly ONE standardized aibot message to a remote issue. Arguments: <remote-issue-id> <message-key> [<pr-number>]. The message-key is one of: success | already-in-progress | already-resolved | not-tracked | cannot-develop. Read the templates from standards/aibot-messages.md, select the one for <message-key>, and substitute {issue_id} (and {mr_link} for success — resolve via `gh pr view <n> --json url --jq .url` / `glab mr view <n> --json web_url --jq .web_url`, with fallback built from `git remote get-url origin`). Detect the remote provider (GitHub -> gh, GitLab -> glab) from the workspace git remote. Then invoke the development/aibot subagent via `task:` with subagent_type 'development/aibot', passing: workspace directory, remote issue id, message key, PR number (if provided) and provider. The subagent posts the message to the remote issue (gh issue comment / glab issue comment) in PT-BR, one message per trigger. Do NOT post anything else and NEVER post the token `@aibot:develop`. Report success or failure; failures are non-blocking.

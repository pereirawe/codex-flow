---
name: flow-sync-jira
description: Reconcile known_issues status with Jira Cloud cards
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

Run the Jira Cloud reconciliation: `scripts/sync-jira.sh sync` — iterate known_issues.md and, for every issue with a `- Jira:` field, transition its card to the status mapped from the local `- Status:` (statusMap in `.codex/jira.json`, defaults: backlog/ready→To Do, in-progress→In Progress, in-review→In Review, in-qa→QA/Testing, in-publish→Ready for Release, resolved→Done). Configuration comes from `.codex/jira.json` (baseUrl, email, projectKey, optional statusMap/authMode) or env vars JIRA_BASE_URL/JIRA_PROJECT_KEY/JIRA_EMAIL, plus JIRA_API_TOKEN (env only — never committed, never logged). Without valid config the sync reports it is disabled and exits cleanly. Sync is non-blocking: network/API/auth failures log a warning and continue; transitions not allowed by the Jira workflow are no-ops with a warning. Report per-issue results and the list of issues without a card.

---
compatibility: Codex with local shell tools; Cursor with Atlassian MCP optional
name: cf-jira
description: >-
  Global Jira Cloud integration for Codex Flow — portfolio project map on
  codetomika.atlassian.net, Atlassian Rovo MCP usage, .codex/jira.json setup,
  and known_issues sync via sync-jira.sh. Use when connecting any repo to Jira,
  creating spaces/boards/issues, or running flow-sync-jira.
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

## When to use

- Wire a repo to Jira or choose the right project key
- Create/search/update Jira issues from the agent (Atlassian MCP)
- Bootstrap `.codex/jira.json` or run `$flow-sync-jira`
- Add a new product to the Codetomika Jira site

## Required reading

1. `~/.codex/flow/standards/jira.md` — config resolution, status map, MCP scopes
2. `~/.codex/flow/config/jira/registry.json` — keys ↔ local repos

## Tooling

1. **Atlassian Rovo MCP** — interactive Jira/Confluence. Prefer for chat-driven work.
2. **`scripts/sync-jira.sh`** / `$flow-sync-jira` — headless mirror of `known_issues.md`.
3. **`scripts/jira-init.sh`** — write project `.codex/jira.json` from registry + global defaults.

## Setup in a project

```bash
# from the product repo
~/.codex/flow/scripts/jira-init.sh
# or force a key:
~/.codex/flow/scripts/jira-init.sh --key REV
```

Requires `config/jira/defaults.json` (copy from `defaults.example.json`) and
`export JIRA_API_TOKEN=...` for sync. Never put the token in JSON.

## Portfolio keys (Codetomika site)

| Key | Product |
|-----|---------|
| KAN | CODETOMIKA (engineering) |
| MKT | Marketing & Leads |
| REV | Revanca |
| VIZ | Vizzupy |
| ISY | ISYNVE |
| HSK | Handshake |

Update `config/jira/registry.json` when adding products; keep one key per product.

## Creating Jira spaces

`createJiraProject` needs org-admin enablement of **manage_jira**, then MCP re-auth
with `manage:jira:agent-interface`. Until then, create spaces in the Jira UI and
keep the registry + `jira-init.sh` in sync.

## Sync command

For full reconciliation of issues that already have a `Jira:` field, follow
`$flow-sync-jira` / `command-skills/flow-sync-jira/SKILL.md`.

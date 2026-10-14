---
name: cf-openwa-notifier
description: Sends WhatsApp notifications via the OpenWA API when an Codex command
  finishes or when an agent needs a response from the user. Use when finishing long
  tasks, reporting results, or asking the user for input when they may be away from
  the terminal ("notificar no whatsapp", "aviso whatsapp", "notificação whatsapp"
  also trigger this skill).
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

# OpenWA Notifier (WhatsApp)

Response language: user's input language → `.codex/locale` (project → global) → EN.

Sends WhatsApp notifications using the OpenWA API.
The script is at `$HOME/.codex/flow/scripts/openwa-notify.sh`.

## Configuration

Credentials are loaded from (priority order):
1. `./.codex/openwa.env` (current project)
2. `~/.codex/flow/.codex/openwa.env` (global)
3. Environment variables `OPENWA_BASE_URL` / `OPENWA_SESSION_ID` / `OPENWA_API_KEY` / `OPENWA_CHAT_ID`

The env file must contain:

```
OPENWA_BASE_URL=https://<host>
OPENWA_SESSION_ID=<session-id>
OPENWA_API_KEY=<api-key>
OPENWA_CHAT_ID=<chat-id>@lid
```

## When to use

**ALWAYS when one of these situations occurs:**

1. **When a command/task finishes** — notify the result (success or failure).
2. **When you need a response from the user** — if the user is not visibly
   active in the terminal, send the question via WhatsApp and wait.
3. **When you hit a blocker** — missing business rule, conflict, failure.
4. **When a milestone completes** — pipeline done, MR created, deploy done.

## How to send notifications

### Simple message (via argument)

```bash
$HOME/.codex/flow/scripts/openwa-notify.sh "Development of issue #42 finished. MR: https://github.com/..."
```

### Message with a title

```bash
$HOME/.codex/flow/scripts/openwa-notify.sh --title "⚠️ Action Needed" \
  "Issue #28 needs business review. The 'max discount' field is not defined."
```

### Message via stdin (for long texts)

```bash
cat <<EOF | $HOME/.codex/flow/scripts/openwa-notify.sh --title "📋 Review Report"
Review finished:
- 2 critical issues found
- 5 warnings
- Test coverage: 87%
EOF
```

## Message template

Always use this pattern:

```
Context: <project>/<branch>
<message body>

Action: <what the user needs to do, if applicable>
```

Example:

```
Context: setup-tecnologia/issue-28-close-issue
Implementation finished. MR created:
https://github.com/pereirawe/setup-tecnologia/pull/15

Action: Review and approve the MR.
```

⚠️ **Do not ask the user whether they want a notification** — just send it.
If the credentials are not configured, the script will fail with a clear
message and you continue normally.
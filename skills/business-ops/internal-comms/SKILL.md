---
name: cf-internal-comms
description: Internal communications strategy — organizational announcements, change
  management, leadership messaging, town halls, newsletter, all-hands.
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

# Internal Communications Skill

Craft clear, effective internal communications.

## Communication Types

### Organizational Announcements
- **Format**: Email or Slack, concise, with FAQ
- **Structure**: What changed → Why → Impact on you → Next steps → Who to ask
- **Timing**: Simultaneous across channels, timezone-aware
- **Tone**: Transparent, direct, empathetic

### Change Management Comms
- **Phase 1 — Awareness**: What's changing and why
- **Phase 2 — Understanding**: How it affects each team
- **Phase 3 — Buy-in**: Benefits and addressing concerns
- **Phase 4 — Commitment**: Timeline, training, support

### Leadership Messages
- **All-hands deck**: Company performance (10 slides max)
- **CEO letter**: Personal, values-driven, forward-looking
- **Team updates**: Specific, actionable, recognition-focused

## Channel Mix
| Channel | Best For | Frequency |
|---------|----------|-----------|
| Email | Formal announcements, documentation | Weekly digest + as needed |
| Slack/Teams | Urgent updates, quick polls | Daily |
| All-hands | Company-wide alignment | Monthly/Quarterly |
| 1:1s | Personal feedback, career | Weekly |
| Newsletter | Culture, wins, learning | Bi-weekly |

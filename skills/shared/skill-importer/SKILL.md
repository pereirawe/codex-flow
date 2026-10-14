---
name: cf-skill-importer
description: Import and update third-party skills as separate Git clones, with discoverable Codex links.
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

Run `~/.codex/flow/scripts/skill-vendor.sh add <url> [--sparse <paths...>]`.
Keep upstream clones in vendor/, never edit upstream files or publish them in
the configuration repo. Use update/list/remove subcommands to maintain them.
Registration generates namespaced adapters in .local/vendor-skills/ and links
them into ~/.agents/skills/. These adapters read the upstream skill on demand.
Do not write OpenCode configuration or permission rules. Network access must
be available for clone/update. Preserve the user's selected sparse paths.

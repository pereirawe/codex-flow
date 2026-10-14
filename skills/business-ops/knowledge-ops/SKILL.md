---
name: cf-knowledge-ops
description: Knowledge operations and management — knowledge base design, information
  architecture, documentation standards, knowledge sharing culture, discovery optimization.
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

# Knowledge Operations Skill

Design and maintain organizational knowledge systems.

## Knowledge Base Design

### Structure Principles
- **Information architecture**: Categories → Topics → Articles → Sections
- **Consistent templates**: How-to, reference, troubleshooting, concept
- **Metadata**: Tags, product version, author, last reviewed, reading time
- **Search optimization**: Keywords, synonyms, clear titles, summaries

### Content Types

| Type | Purpose | Template |
|------|---------|----------|
| How-to guide | Step-by-step task completion | Goal → Prerequisites → Steps → Verification |
| Reference | Facts, specs, configurations | Consistent by type (API, config, schema) |
| Troubleshooting | Problem → solution | Symptom → Cause → Resolution → Prevention |
| Concept | Explanatory, background | Definition → Why it matters → How it works |
| Tutorial | Learning-oriented | Learning objectives → Step-by-step → Practice → Quiz |

### Maintenance
- Content freshness scoring (last reviewed date)
- Ownership per topic area
- Stale content archival workflow
- User feedback loop (was this helpful?)
- Analytics: search queries, top articles, bounce rate

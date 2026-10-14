---
name: cf-ads-campaign
description: Ad campaign strategy, copywriting, and performance optimization across
  Google Ads, Meta, LinkedIn, and other platforms.
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

# Ads Campaign Skill

Create, manage, and optimize advertising campaigns.

## Capabilities

- Campaign strategy & structured planning
- Ad copywriting for different platforms and formats
- Performance analysis and A/B test design
- Budget allocation and bid strategy recommendations

## Platforms

- Google Ads (Search, Display, Shopping, YouTube)
- Meta Ads (Facebook, Instagram)
- LinkedIn Ads
- Native advertising (Outbrain, Taboola)

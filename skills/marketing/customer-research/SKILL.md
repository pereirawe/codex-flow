---
name: cf-customer-research
description: Customer and market research — ICP definition, persona development, competitor
  intelligence, survey design, insight synthesis.
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

# Customer Research Skill

Understand your audience deeply enough to market effectively.

## Research Types

### Primary Research
- **User interviews**: 1:1 structured conversations
- **Surveys**: Quantitative validation at scale
- **Usage analysis**: Behavioral data from product analytics
- **Win/loss analysis**: Why customers buy or churn

### Secondary Research
- **Competitor analysis**: Positioning, messaging, reviews
- **Market reports**: Industry trends, category data
- **Social listening**: Sentiment, pain points, terminology
- **Review mining**: G2, Capterra, Reddit, App Store

## ICP Definition Template

| Dimension | Questions |
|-----------|-----------|
| Demographics | Industry, company size, role, seniority, location |
| Goals | What does success look like for them? |
| Pain points | What frustrates them about current solutions? |
| Current solution | What do they use today? What's missing? |
| Buying triggers | What event causes them to search for a solution? |
| Decision process | Who's involved? What's the evaluation criteria? |
| Objections | Why might they not buy? |
| Message that resonates | What hook would get their attention? |

## Persona Development
1. Name and role title
2. Demographics and context
3. Goals and motivations (explicit + implicit)
4. Pain points and fears
5. Current behavior and tools
6. Decision criteria
7. Objections and barriers
8. Where they get information
9. What a perfect solution looks like
10. Real quote from research

## Insight Synthesis
- Affinity mapping: group findings into themes
- Opportunity sizing: which problems affect the most users?
- Jobs To Be Done: functional, emotional, social jobs
- Customer journey map: awareness → evaluation → purchase → retention → advocacy

## Related Skills
- `marketing-plan` — apply research to strategy
- `copywriting` — use customer language in copy
- `competitor-intelligence` — market positioning

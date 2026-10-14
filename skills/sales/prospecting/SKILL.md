---
name: cf-prospecting
description: Sales prospecting and lead generation — ICP scoring, account research,
  intent signals, multi-channel outreach sequences, social selling on LinkedIn.
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

# Prospecting Skill

Build targeted prospect lists with research-backed personalization.

## ICP Scoring

| Criterion | Weight | Scoring Method |
|-----------|--------|----------------|
| Company fit | 25% | Revenue, employee count, industry, location |
| Tech fit | 20% | Has complementary tools, missing yours, recent tech changes |
| Funding/Growth | 15% | Recent round, hiring sprees, expansion announcements |
| Buyer role | 20% | Title, seniority, decision authority, function |
| Pain signals | 20% | Job postings (hiring for what you solve), G2 complaints, leadership changes |

## Social Selling (LinkedIn)
- **Profile**: Optimized headline, summary with value prop, relevant content
- **Content**: Share insights (60%), industry news (20%), personal stories (20%)
- **Engagement**: Comment on target posts before DMing — warm the connection
- **Connection Request**: Personalized note referencing specific content or mutual connection
- **Follow-up**: After connection accepted, send value (not pitch) within 48 hours

## Multi-Channel Sequence

| Touch | Channel | Timing | Message |
|-------|---------|--------|---------|
| 1 | LinkedIn | Day 0 | Connection request with personalized note |
| 2 | Email | Day 1 | Value-first: insight or resource relevant to their role |
| 3 | LinkedIn | Day 4 | Comment on their post (public) + value message (DM) |
| 4 | Email | Day 7 | Case study from similar company/role |
| 5 | Phone | Day 10 | Quick call with specific value statement |
| 6 | Email | Day 14 | Breakup: "I'll stop reaching out unless you tell me otherwise" |

## Account Research Template
- Company: website, funding, tech stack, recent news, competitors
- Person: LinkedIn profile, recent posts, past roles, mutual connections
- Pain: job postings they're hiring for, reviews of current vendor, trigger events
- Angle: how your solution maps to their specific context

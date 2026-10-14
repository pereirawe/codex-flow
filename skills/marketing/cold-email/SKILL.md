---
name: cf-cold-email
description: B2B cold email outreach — sequence architecture, offer crafting, deliverability,
  reply rate optimization, Hormozi frameworks.
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

# Cold Email Skill

Write B2B cold emails that get replies.

## Core Principles
- **Value first**: The email must be worth reading even if they don't buy
- **Personalization**: Research-backed, not template fill-ins
- **Brevity**: Under 100 words for first email
- **Clear ask**: What's the next step?
- **Low friction**: One click to respond

## Hormozi Framework
**Problem → Agitate → Solution → Proof → Offer → CTA**

1. **Problem**: "Most SaaS companies waste 30% of their ad spend on irrelevant clicks."
2. **Agitate**: "That's $30K gone for every $100K in spend."
3. **Solution**: "We built a tool that identifies wasted spend automatically."
4. **Proof**: "Customers reduce wasted spend by 40% on average."
5. **Offer**: "Free audit of your last 30 days of ad spend — takes 5 minutes."
6. **CTA**: "Worth a quick call to see if we can help?"

## Sequence Architecture

| Email | Timing | Goal | Length |
|-------|--------|------|--------|
| 1 | Day 0 | Value + CTA | 3-5 lines |
| 2 | Day 3 | Different angle | 3-5 lines |
| 3 | Day 7 | Case study/proof | 5-8 lines |
| 4 | Day 14 | Breakup/alt offer | 2-3 lines |
| 5 | Day 21 | Final re-engagement | 2-3 lines |

## Deliverability Checklist
- Custom sending domain (not generic Gmail)
- Warm up before sending to cold lists
- SPF, DKIM, DMARC configured
- Text-only first email (no images/links initially)
- Avoid: spam trigger words, excessive exclamation, ALL CAPS
- Send 20-50 per day per inbox initially
- Track: open rate (>40% good), reply rate (>3% good), bounce rate (<3%)

## Related Skills
- `copywriting` — email copy craft
- `email-marketing` — lifecycle integration
- `competitor-intelligence` — research for personalization

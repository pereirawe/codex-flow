---
name: cf-email-marketing
description: Lifecycle email strategy and execution — welcome flows, nurture sequences,
  retention campaigns, abandoned cart, winback, and launch emails with deliverability
  best practices.
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

# Email Marketing Skill

Build email programs that drive revenue across the customer lifecycle.

## Lifecycle Email Types

| Type | Trigger | Goal |
|------|---------|------|
| Welcome | Signup | Activation, first value |
| Nurture | Lead score/behavior | Education, trust, demo request |
| Abandoned cart | Cart abandonment | Recover revenue |
| Browse abandonment | Page visit without action | Re-engage interest |
| Post-purchase | Purchase confirmation | Reduce buyer's remorse, upsell |
| Re-engagement | Inactivity (30/60/90 days) | Win back or churn |
| Milestone | Anniversary, usage milestones | Loyalty, advocacy |

## Email Design Rules

**Subject line**: 30-50 chars, personalized, curiosity or value-driven
**Preview text**: 85-100 chars, reinforces subject, not redundant
**Preheader**: Hidden hero — use for secondary CTA or urgency
**Body**: One goal per email. One primary CTA. Scannable structure.
**Personalization**: Beyond first name — segment behavior, preferences, lifecycle stage
**Send time**: Test across segments. B2B: weekday mornings. B2C: evenings/weekends.

## Sequence Architecture

### Welcome Flow (3-5 emails)
1. Confirm signup, set expectations, deliver first value
2. Educate on key features or content
3. Social proof and case studies
4. Offer or trial extension
5. Direct ask (purchase, demo, upgrade)

### Nurture Sequence (5-8 emails)
- Problem awareness → Solution education → Authority building → Offer → Urgency
- Mix: educational content (60%), social proof (20%), direct offers (20%)

### Abandoned Cart (3 emails)
1. Reminder + product benefit (1 hour)
2. Social proof + urgency (24 hours)
3. Incentive (48 hours)

## Deliverability Checklist
- SPF, DKIM, DMARC configured
- List hygiene: remove bounces, unengaged subscribers
- Avoid spam trigger words in subject/body
- Plain text + HTML multipart
- Text-to-image ratio ≥ 60:40
- Test deliverability before send

## Related Skills
- `copywriting` — email copy
- `conversion-optimization` — CTA optimization
- `marketing-analytics` — performance measurement

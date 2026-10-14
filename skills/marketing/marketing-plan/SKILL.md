---
name: cf-marketing-plan
description: Comprehensive marketing and campaign planning — GTM strategy, marketing
  calendars, budget allocation, channel mix, integrated campaigns.
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

# Marketing Plan Skill

Create structured marketing plans aligned with business goals.

## Plan Structure

### 1. Executive Summary
- Business objectives, target outcomes, budget, timeline

### 2. Situation Analysis
- Market overview: size, growth, trends
- Competitive landscape: direct, indirect, emerging
- SWOT: internal strengths/weaknesses, external opportunities/threats
- Customer insights: ICP, personas, buying journey

### 3. Goals & KPIs
- SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound
- Leading indicators: traffic, leads, engagement
- Lagging indicators: revenue, CAC, LTV, retention

### 4. Strategy & Positioning
- Value proposition: what makes you the best choice?
- Positioning: how you win against alternatives
- Messaging hierarchy: claim → proof → personality

### 5. Channel Mix & Tactics

| Channel | Role | Budget % | Goal |
|---------|------|----------|------|
| Organic search | Long-term capture | 20% | Traffic, authority |
| Paid ads | Demand capture | 30% | Leads, revenue |
| Email | Retention, upsell | 10% | LTV, re-engagement |
| Social | Awareness, community | 15% | Engagement, reach |
| Content | Education, SEO | 15% | Traffic, trust |
| Events/PR | Authority, network | 10% | Pipeline, awareness |

### 6. Content & Creative Plan
- Content pillars and topics
- Creative formats and templates
- Editorial calendar (monthly view)

### 7. Budget & Resources
- Total budget with allocation by channel
- Headcount, tools, agency costs
- Expected ROI by channel

### 8. Measurement Plan
- Dashboards and reporting cadence
- Attribution model
- Review and optimization schedule

## Related Skills
- `marketing-analytics` — measurement
- `content-strategy` — content planning
- `launch` — campaign execution
- `pricing` — monetization strategy

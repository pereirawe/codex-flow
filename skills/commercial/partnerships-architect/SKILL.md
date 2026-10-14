---
name: cf-partnerships-architect
description: Partnership and alliance development — partner identification, program
  design, co-selling motions, ecosystem strategy, joint GTM.
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

# Partnerships Architect Skill

Build channel and alliance programs that scale revenue.

## Partner Types

| Type | Relationship | Revenue Model | Best For |
|------|-------------|---------------|----------|
| Referral | Refer leads, no deep integration | 10-20% first-year rev | Complementary products |
| Reseller | Sell your product as part of their offering | 20-40% margin | Geographical expansion |
| Technology | API integration, co-built solution | Revenue share or flat fee | Ecosystem lock-in |
| Strategic | Deep GTM alignment, joint product | Custom revenue share | Market creation |
| Agency/Consulting | Implement your solution for clients | Referral fee + services | Enterprise adoption |

## Partner Program Design

### Tier Structure
| Tier | Requirements | Benefits |
|------|-------------|----------|
| Silver | 1-5 deals/year, 1 certified | Lead sharing, basic support |
| Gold | 5-20 deals/year, 3 certified | Co-marketing, priority support, MDF |
| Platinum | 20+ deals/year, 5+ certified | Joint GTM, executive sponsor, strategic MDF |

### Key Metrics
- Partner-sourced pipeline ($)
- Partner-influenced revenue ($)
- Partner-attributed revenue ($)
- Time to partner productivity
- Partner NPS
- Co-sell win rate

## Joint GTM Motion
1. **Align**: ICP, value prop, messaging for joint offering
2. **Enable**: Partner team trained, collateral created, demo ready
3. **Launch**: Coordinated announcement, co-branded content
4. **Execute**: Pipeline reviews, co-selling cadence
5. **Measure**: Attribution, revenue, partner satisfaction

## Related Skills
- `channel-economics` — financial modeling
- `commercial-forecasting` — revenue prediction
- `marketing-plan` — GTM integration

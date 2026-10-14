---
name: cf-pricing-strategist
description: Pricing strategy and optimization — value-based pricing, packaging design,
  monetization models, discounting governance, price elasticity.
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

# Pricing Strategist Skill

Design pricing that captures value without losing deals.

## Pricing Models

| Model | Best For | Example |
|-------|----------|---------|
| Flat rate | Simple, single product | $99/mo for everything |
| Tiered | Segmented by usage/features | Basic $49, Pro $99, Enterprise $299 |
| Per-seat | Team collaboration tools | $15/user/mo |
| Usage-based | Consumption-driven | $0.10 per API call |
| Hybrid | Base + usage | $99/mo base + $0.05/unit overage |
| Freemium | Top-of-funnel | Free tier + paid upgrades |

## Packaging Strategy

### Good-Better-Best Framework
- **Good**: Entry price, limited features, captures budget-conscious
- **Better**: Most popular, best value, majority of customers
- **Best**: Full features, premium support, highest ACV

### Decoy Effect
Place a strategically unattractive option to make your target tier look better.

## Discounting Governance
- Standard discount range: 10-20% (no approval needed)
- Moderate discount: 20-30% (manager approval)
- Heavy discount: 30%+ (VP/CRO approval)
- Never discount below unit economics threshold
- Discount in exchange for term commitment (annual > monthly)
- Track discount rate by deal size, segment, and rep

## Price Increase Playbook
1. Communicate value delivered before announcing increase
2. Grandfather existing customers for 6-12 months
3. Frame as investment in new capabilities
4. Offer annual prepay at old rate as transition

## Related Skills
- `deal-desk` — approval workflows
- `channel-economics` — partner pricing
- `financial-modeling` — unit economics
- `proposals` — pricing presentation

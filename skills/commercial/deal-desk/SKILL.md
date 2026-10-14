---
name: cf-deal-desk
description: Deal desk and deal structuring — non-standard terms, discount approval,
  executive review, margin protection, deal governance.
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

# Deal Desk Skill

Structure profitable deals with proper governance.

## Deal Review Checklist

- [ ] MEDDIC fully qualified (Metrics, Economic Buyer, Decision Criteria, Decision Process, Identify Pain, Champion)
- [ ] Discount within approved authority levels
- [ ] Contract terms reviewed (liability, termination, SLA)
- [ ] Margin maintained above threshold
- [ ] Implementation capacity confirmed
- [ ] Payment terms standard or justified exception
- [ ] Multi-year commitment secured for heavy discounts
- [ ] Competitive threat verified (not fabricated)

## Approval Escalation

| Deal Complexity | Approver | Turnaround |
|----------------|----------|------------|
| Standard pricing, <$50K ACV | AE | None needed |
| 20-30% discount, $50-100K | Sales Manager | 24h |
| Custom terms, $100-250K | VP Sales + Legal | 48h |
| Strategic deal, $250K+ | CRO + CFO | 1 week |

## Deal Structuring Playbook
- **Annual prepay**: Offer 2 months free to convert monthly → annual
- **Multi-year**: Discount 5-10% per year for 2-3 year commitments
- **Expansion clause**: Pre-negotiate pricing for additional seats/usage
- **Professional services**: Bundle or separate? Bundled increases ACV, separated protects margin
- **Trial-to-paid**: Time-limited trial with credit card for conversion

## Related Skills
- `pricing-strategist` — pricing context
- `sales-pipeline` — deal qualification
- `proposals` — proposal structure
- `commercial-forecasting` — revenue impact

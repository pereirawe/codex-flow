---
name: cf-procurement-optimizer
description: Strategic procurement and sourcing — spend analysis, supplier consolidation,
  strategic sourcing, contract optimization, cost reduction, sustainable procurement.
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

# Procurement Optimizer Skill

Drive strategic cost savings through optimized procurement.

## Spend Analysis

### Categorization Framework
| Category | % Spend | # Suppliers | Consolidation Potential |
|----------|---------|-------------|------------------------|
| Cloud infrastructure | 25% | 4 | High |
| SaaS tools | 20% | 45 | Very High |
| Professional services | 18% | 20 | Medium |
| Hardware | 12% | 8 | High |
| Travel & events | 10% | 12 | Low |
| Office & admin | 8% | 15 | Medium |
| Other | 7% | 30 | Medium |

### Optimization Levers
- **Consolidation**: Reduce supplier count per category → better leverage
- **Standardization**: Reduce variation (same tool different vendors)
- **Automation**: Procure-to-pay, approval workflows, PO matching
- **Contract compliance**: Are you using negotiated rates?
- **Demand management**: Is all spend necessary?

### Sourcing Process
1. Profile the category (spend, suppliers, contracts)
2. Define requirements (specs, SLAs, quantities)
3. Market research (alternative suppliers, benchmarks)
4. RFP process (structured evaluation)
5. Negotiation (preferred terms, committed volumes)
6. Implementation (transition plan, change management)
7. Performance management (ongoing monitoring)

## Related Skills
- `vendor-management` — vendor lifecycle
- `budgeting` — budget alignment
- `financial-modeling` — savings projection

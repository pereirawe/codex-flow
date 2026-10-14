---
name: cf-data-governance
description: Data governance and quality — data catalog, lineage, quality frameworks,
  metadata management, compliance (LGPD/GDPR), data policies.
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

# Data Governance Skill

Establish trust in data through governance and quality.

## Governance Framework

### Data Catalog
- Business glossary: canonical definitions for every metric
- Technical metadata: source, schema, transformation logic
- Ownership: data owner and steward per domain
- Tags: PII, sensitive, critical, experimental

### Data Lineage
- Source → staging → transformation → consumption
- Impact analysis: "what breaks if this source changes?"
- Root cause: "why did this report change?"

### Data Quality Dimensions

| Dimension | Definition | Check |
|-----------|------------|-------|
| Accuracy | Data reflects reality | Cross-reference with source |
| Completeness | All required data present | Null checks, row count |
| Consistency | Same values across systems | Cross-system reconciliation |
| Timeliness | Data is current | Freshness SLA monitoring |
| Uniqueness | No duplicate records | Primary key validation |
| Validity | Data conforms to format | Schema validation |

### Quality Rules
- Freshness SLA per table
- Row count expectations (minimum, maximum, % change)
- Null rate thresholds per critical column
- Referential integrity checks
- Custom business rules

## Compliance
- PII classification and masking
- Retention policies by data type
- Access controls (read, write, admin per role)
- Audit logging for sensitive data access
- LGPD/GDPR: right to deletion workflow

## Related Skills
- `analytics-engineering` — data pipeline governance
- `report-automation` — data quality reporting

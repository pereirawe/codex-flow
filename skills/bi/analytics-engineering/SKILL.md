---
name: cf-analytics-engineering
description: Data pipeline and warehouse engineering — ETL/ELT, dbt modeling, data
  modeling (star/snowflake), orchestration, data quality testing.
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

# Analytics Engineering Skill

Build reliable data infrastructure for analytics and reporting.

## Data Modeling Patterns

### Star Schema
- **Fact tables**: Measures, metrics, events (sales, clicks, signups)
- **Dimension tables**: Descriptive attributes (customer, product, time, location)
- Grain: one row per event at the most atomic level

### Slowly Changing Dimensions (SCD)
- Type 1: Overwrite (no history)
- Type 2: Add row with date range (full history)
- Type 3: Add column (limited history)

### dbt Best Practices
- Models: staging → intermediate → marts (gold layer)
- Staging: 1:1 with source, minimal transformations
- Intermediate: business logic, joins, aggregations
- Marts: ready-for-consumption, documented with descriptions
- Tests: not null, unique, accepted values, relationships, custom

## Pipeline Design
- **Extract**: Incremental where possible, full refresh for dimensions
- **Load**: Raw layer preserves source structure
- **Transform**: dbt for SQL transformations, Python for complex logic
- **Orchestrate**: Airflow/Dagster — DAG per domain, alerts on failure
- **Monitor**: Row count checks, freshness, schema drift detection

## Quality Gates
- Freshness SLA: how recent must data be?
- Completeness: no nulls in key fields
- Uniqueness: primary keys unique
- Referential integrity: foreign keys match existing records

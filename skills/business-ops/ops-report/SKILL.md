---
name: cf-ops-report
description: Internal delivery ops report — issue age, LLM wall-clock/token ledger,
  skipped reviewers, steward classes. Use when the user asks for ops report,
  cost report, gargalos, "relatório interno", wall_ms, issue-runs, or to inspect
  delivery efficiency. Never use for client-facing progress (use cf-progress-report).
---

## Codex runtime contract

This workflow was migrated to Codex. Read `~/.codex/flow/docs/runtime.md`
before its first use. Resolve scripts from `~/.codex/flow/scripts/` and run
them with CWD set to the intended project.

# Ops Report Skill

Produce an **internal** ops snapshot. Audience is the delivery team, not the
client. Do not attach brand logos or send via client channels.

## Generator

```bash
bash ~/.codex/flow/scripts/ops-report.sh [--date YYYY-MM-DD] [--project DIR]
```

Writes `.codex/reports/ops-<date>.md`.

## Sections

1. Open issues by age (flag `in-review` / `in-qa` ≥ 3 days as bottlenecks).
2. Cost ledger top issues by `wall_ms` from `.codex/metrics/issue-runs.jsonl`.
3. Recent steward lessons from `~/.codex/flow/.local/steward/ledger.jsonl`.

## Related

- Per issue: `flow-issue-cost.sh <id>`
- Client report: `cf-progress-report` / `progress-report.sh`

#!/usr/bin/env bash
# flow-issue-cost.sh — Summarize .codex/metrics/issue-runs.jsonl for one issue.
# Usage: flow-issue-cost.sh <issue-id>
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

ID="${1:-}"
[[ "$ID" =~ ^[0-9]+$ ]] || { echo "Usage: flow-issue-cost.sh <issue-id>" >&2; exit 2; }

LEDGER="$PROJECT_ISSUES_DIR/metrics/issue-runs.jsonl"
if [[ ! -f "$LEDGER" ]]; then
  echo "No metrics ledger at $LEDGER"
  exit 0
fi

export FIC_ID="$ID" FIC_LEDGER="$LEDGER"
python3 - <<'PY'
import json, os, collections
issue = int(os.environ["FIC_ID"])
rows = []
with open(os.environ["FIC_LEDGER"], encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            row = json.loads(line)
        except json.JSONDecodeError:
            continue
        if row.get("issue") == issue:
            rows.append(row)
if not rows:
    print(f"issue #{issue}: no metric rows")
    raise SystemExit(0)
wall = sum(r.get("wall_ms") or 0 for r in rows)
tin = sum(r.get("input_tokens") or 0 for r in rows)
tout = sum(r.get("output_tokens") or 0 for r in rows)
by_step = collections.Counter()
for r in rows:
    by_step[r.get("step", "?")] += r.get("wall_ms") or 0
print(f"issue #{issue}: steps={len(rows)} wall_ms={wall} input_tokens={tin or 'null'} output_tokens={tout or 'null'}")
for step, ms in by_step.most_common():
    print(f"  {step}: {ms} ms")
PY

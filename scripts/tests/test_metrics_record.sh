#!/usr/bin/env bash
# test_metrics_record.sh — JSONL append + flow-issue-cost summary.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib.sh"
t_begin "test_metrics_record"

REC="$HERE/../metrics-record.sh"
COST="$HERE/../flow-issue-cost.sh"
[[ -f "$REC" ]] || { t_fail "metrics-record.sh missing"; t_finish; exit 1; }
[[ -f "$COST" ]] || { t_fail "flow-issue-cost.sh missing"; t_finish; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"
git init -q
git config user.email "test@example.com"
git config user.name "Test"
mkdir -p .codex
# config.sh resolves PROJECT_ISSUES_DIR from git toplevel .codex

bash "$REC" --issue 12 --flow develop-full --step implement --wall-ms 1500 --result ok
bash "$REC" --issue 12 --flow develop-full --step senior-review --profile backend \
  --wall-ms 3000 --input-tokens 100 --output-tokens 40 --agents development/senior-reviewers/backend
bash "$REC" --issue 99 --flow discovery --step route --wall-ms 10 --result skip

LEDGER=".codex/metrics/issue-runs.jsonl"
[[ -f "$LEDGER" ]] && t_ok "ledger created" || t_fail "ledger created"
lines=$(wc -l <"$LEDGER" | tr -d ' ')
assert_eq "3" "$lines" "three rows written"

python3 -c '
import json
rows=[json.loads(l) for l in open(".codex/metrics/issue-runs.jsonl")]
assert rows[0]["issue"]==12 and rows[0]["wall_ms"]==1500
assert rows[1]["input_tokens"]==100
assert rows[1]["agents"]==["development/senior-reviewers/backend"]
print("ok")
' && t_ok "row fields" || t_fail "row fields"

OUT=$(bash "$COST" 12)
printf '%s' "$OUT" | grep -q 'wall_ms=4500' && t_ok "issue cost wall sum" || t_fail "issue cost wall sum ($OUT)"
printf '%s' "$OUT" | grep -q 'implement' && t_ok "issue cost by step" || t_fail "issue cost by step"

t_finish

#!/usr/bin/env bash
# test_progress_ops_report.sh — client progress + internal ops generators.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib.sh"
t_begin "test_progress_ops_report"

PROG="$HERE/../progress-report.sh"
OPS="$HERE/../ops-report.sh"
[[ -f "$PROG" ]] || { t_fail "progress-report.sh missing"; t_finish; exit 1; }
[[ -f "$OPS" ]] || { t_fail "ops-report.sh missing"; t_finish; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"
mkdir -p .codex/metrics docs/progress

cat >.codex/known_issues.md <<'EOF'
## Known Issues

### 1. Login OAuth
- Status: in-progress
- Type: feat
- Severity: high
- Priority: P1
- Started: 2026-11-01T10:00

### 2. CSV export
- Status: ready
- Type: feat
- Severity: medium
- Priority: P2
EOF

cat >.codex/resolved_issues.md <<'EOF'
## Resolved

### 3. Fix typo
- Status: resolved
- Type: chore
- Severity: low
- Priority: P3
- Resolved: 2026-11-04T12:00
- Durations: backlog=1h review=0h total=2h
EOF

cat >.codex/progress-modules.json <<'EOF'
{
  "total_hours": 10,
  "modules": [
    {"name": "Auth", "hours": 6, "issues": [1]},
    {"name": "Export", "hours": 4, "issues": [2, 3]}
  ]
}
EOF

echo '{"issue":1,"flow":"develop","step":"implement","wall_ms":5000,"input_tokens":10,"output_tokens":2,"result":"ok"}' \
  >.codex/metrics/issue-runs.jsonl

OUT=$(bash "$PROG" --date 2026-11-05 --project "$TMP" | head -n1)
[[ -f "$OUT" ]] && t_ok "progress md written" || t_fail "progress md written"
assert_contains "$OUT" "Resumo executivo" "progress has executive summary"
assert_contains "$OUT" "Auth" "progress has module"

OPS_OUT=$(bash "$OPS" --date 2026-11-05 --project "$TMP" | head -n1)
[[ -f "$OPS_OUT" ]] && t_ok "ops md written" || t_fail "ops md written"
assert_contains "$OPS_OUT" "Cost ledger" "ops has ledger"
assert_contains "$OPS_OUT" "Internal only" "ops marked internal"

t_finish

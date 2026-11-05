#!/usr/bin/env bash
# ops-report.sh — Internal ops report: age, cost ledger, skipped reviewers, steward.
# Usage: ops-report.sh [--date YYYY-MM-DD] [--project DIR]
set -euo pipefail

DATE="$(date +%Y-%m-%d)"
PROJECT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --date) DATE="$2"; shift 2 ;;
    --project) PROJECT="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: ops-report.sh [--date YYYY-MM-DD] [--project DIR]" >&2
      exit 0 ;;
    *) echo "Unknown: $1" >&2; exit 2 ;;
  esac
done

if [[ -n "$PROJECT" ]]; then
  ROOT="$(cd "$PROJECT" && pwd -P)"
else
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd -P)"
fi

CODEX="$ROOT/.codex"
ISSUES="$CODEX/known_issues.md"
RESOLVED="$CODEX/resolved_issues.md"
LEDGER="$CODEX/metrics/issue-runs.jsonl"
STEWARD="${HOME}/.codex/flow/.local/steward/ledger.jsonl"
OUT_DIR="$CODEX/reports"
mkdir -p "$OUT_DIR"

export OR_ISSUES="$ISSUES" OR_RESOLVED="$RESOLVED" OR_LEDGER="$LEDGER"
export OR_STEWARD="$STEWARD" OR_DATE="$DATE" OR_OUT="$OUT_DIR/ops-$DATE.md"
export OR_ROOT="$ROOT"

python3 - <<'PY'
import collections, json, os, re, pathlib
from datetime import datetime, timezone

def parse_issues(path):
    items, cur = [], None
    if not os.path.isfile(path):
        return items
    with open(path, encoding="utf-8") as f:
        for raw in f:
            line = raw.rstrip("\n")
            m = re.match(r"^### (\d+)\. (.*)$", line)
            if m:
                if cur:
                    items.append(cur)
                cur = {"id": int(m.group(1)), "title": m.group(2), "fields": {}}
                continue
            if cur is None:
                continue
            mm = re.match(r"^- ([A-Za-z][A-Za-z ]*): ?(.*)$", line)
            if mm:
                cur["fields"][mm.group(1)] = mm.group(2).strip()
    if cur:
        items.append(cur)
    return items

def parse_ts(s):
    if not s or s == "-":
        return None
    s = s.strip().replace("Z", "")
    for cand in (s, s[:16], s[:10]):
        try:
            return datetime.fromisoformat(cand)
        except Exception:
            continue
    return None

active = parse_issues(os.environ["OR_ISSUES"])
now = datetime.now(timezone.utc).replace(tzinfo=None)
lines = []
lines.append(f"# Ops report — {pathlib.Path(os.environ['OR_ROOT']).name}")
lines.append("")
lines.append(f"- **Date:** {os.environ['OR_DATE']}")
lines.append("")

# Age / bottlenecks
lines.append("## Open issues by age")
lines.append("")
bottlenecks = []
for it in active:
    st = it["fields"].get("Status", "backlog")
    if st in ("resolved",):
        continue
    started = parse_ts(it["fields"].get("Started") or it["fields"].get("Ready") or it["fields"].get("Opened"))
    age = (now - started).days if started else None
    bottlenecks.append((age or -1, it, st, started))
bottlenecks.sort(reverse=True, key=lambda x: x[0])
for age, it, st, started in bottlenecks[:25]:
    age_s = f"{age}d" if age >= 0 else "?"
    mark = ""
    if st in ("in-review", "in-qa") and age is not None and age >= 3:
        mark = " **GARGALO**"
    lines.append(f"- #{it['id']} `{st}` age={age_s} — {it['title']}{mark}")
lines.append("")

# Ledger costs
ledger = os.environ["OR_LEDGER"]
lines.append("## Cost ledger (window = all rows in metrics)")
lines.append("")
if os.path.isfile(ledger):
    by_issue = collections.defaultdict(lambda: {"wall": 0, "in": 0, "out": 0, "steps": 0, "skipped": 0})
    with open(ledger, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
            except json.JSONDecodeError:
                continue
            b = by_issue[row.get("issue")]
            b["wall"] += row.get("wall_ms") or 0
            b["in"] += row.get("input_tokens") or 0
            b["out"] += row.get("output_tokens") or 0
            b["steps"] += 1
            if row.get("step") == "reviewers-skipped" or row.get("result") == "skip":
                b["skipped"] += 1
    top = sorted(by_issue.items(), key=lambda kv: -kv[1]["wall"])[:15]
    if not top:
        lines.append("- Ledger exists but has no rows.")
    else:
        lines.append("| Issue | wall_ms | tokens_in | tokens_out | steps |")
        lines.append("|------:|--------:|----------:|-----------:|------:|")
        for iid, b in top:
            lines.append(
                f"| #{iid} | {b['wall']} | {b['in'] or '—'} | {b['out'] or '—'} | {b['steps']} |"
            )
else:
    lines.append("- No `.codex/metrics/issue-runs.jsonl` yet.")
lines.append("")

# Steward
stew = os.environ["OR_STEWARD"]
lines.append("## Steward lessons (recent)")
lines.append("")
if os.path.isfile(stew):
    rows = []
    with open(stew, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                rows.append(json.loads(line))
            except json.JSONDecodeError:
                continue
    for row in rows[-8:]:
        lines.append(
            f"- `{row.get('flow')}` {row.get('result')} {row.get('class')}: {row.get('note', '')[:120]}"
        )
else:
    lines.append("- No steward ledger.")
lines.append("")
lines.append("---")
lines.append("_Internal only — do not send to clients._")

path = os.environ["OR_OUT"]
pathlib.Path(path).write_text("\n".join(lines) + "\n", encoding="utf-8")
print(path)
PY

#!/usr/bin/env bash
# Short memory for discovery, develop, and develop-full.
# lessons --flow NAME
# record --flow NAME --step STEP --result ok|fail|fix|blocked --class CLASS --note TEXT
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LEDGER="${FLOW_STEWARD_LEDGER:-$ROOT/.local/steward/ledger.jsonl}"
cmd="${1:-}"
shift || true

flow=""
step=""
result=""
class=""
note=""

usage() {
  echo "usage: flow-steward.sh lessons --flow NAME | record --flow NAME --step STEP --result ok|fail|fix|blocked --class CLASS --note TEXT" >&2
  exit 2
}

[[ -n "$cmd" ]] || usage
while [[ $# -gt 0 ]]; do
  case "$1" in
    --flow) flow="${2:-}"; shift 2 ;;
    --step) step="${2:-}"; shift 2 ;;
    --result) result="${2:-}"; shift 2 ;;
    --class) class="${2:-}"; shift 2 ;;
    --note) note="${2:-}"; shift 2 ;;
    *) usage ;;
  esac
done

case "$flow" in
  discovery|develop|develop-full) ;;
  *) echo "flow must be discovery, develop, or develop-full" >&2; exit 2 ;;
esac

export FLOW_STEWARD_LEDGER="$LEDGER"
export FLOW_STEWARD_CMD="$cmd"
export FLOW_STEWARD_FLOW="$flow"
export FLOW_STEWARD_STEP="$step"
export FLOW_STEWARD_RESULT="$result"
export FLOW_STEWARD_CLASS="$class"
export FLOW_STEWARD_NOTE="$note"

python3 - <<'PY'
import json, os, sys
from pathlib import Path

ledger = Path(os.environ["FLOW_STEWARD_LEDGER"])
cmd = os.environ["FLOW_STEWARD_CMD"]
flow = os.environ["FLOW_STEWARD_FLOW"]

if cmd == "lessons":
    if ledger.is_file():
        rows = []
        for line in ledger.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
            except json.JSONDecodeError:
                continue
            if row.get("flow") == flow and row.get("result") in ("fix", "blocked"):
                rows.append(row)
        for row in rows[-8:]:
            note = (row.get("note") or "").replace("\n", " ")[:160]
            print(f"{row.get('result')} {row.get('class')}: {note}")
    raise SystemExit(0)

if cmd != "record":
    raise SystemExit(2)

result = os.environ["FLOW_STEWARD_RESULT"]
if result not in ("ok", "fail", "fix", "blocked"):
    print("bad result", file=sys.stderr)
    raise SystemExit(2)
cls = os.environ["FLOW_STEWARD_CLASS"][:80]
if not cls:
    print("class required", file=sys.stderr)
    raise SystemExit(2)
row = {
    "flow": flow,
    "step": os.environ["FLOW_STEWARD_STEP"][:80],
    "result": result,
    "class": cls,
    "note": os.environ["FLOW_STEWARD_NOTE"].replace("\n", " ")[:160],
}
ledger.parent.mkdir(parents=True, exist_ok=True)
with ledger.open("a", encoding="utf-8") as handle:
    handle.write(json.dumps(row, ensure_ascii=False) + "\n")
print("recorded")
PY

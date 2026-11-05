#!/usr/bin/env bash
# metrics-record.sh — Append one JSONL row to .codex/metrics/issue-runs.jsonl
# Usage:
#   metrics-record.sh --issue ID --flow NAME --step STEP [--profile P] \
#     [--started ISO] [--ended ISO] [--wall-ms N] \
#     [--input-tokens N] [--output-tokens N] [--model M] \
#     [--agents a,b] [--result ok|fail|skip] [--session PATH]
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

ISSUE=""; FLOW=""; STEP=""; PROFILE=""
STARTED=""; ENDED=""; WALL=""
IN_TOK=""; OUT_TOK=""; MODEL=""
AGENTS=""; RESULT="ok"; SESSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --issue) ISSUE="$2"; shift 2 ;;
    --flow) FLOW="$2"; shift 2 ;;
    --step) STEP="$2"; shift 2 ;;
    --profile) PROFILE="$2"; shift 2 ;;
    --started) STARTED="$2"; shift 2 ;;
    --ended) ENDED="$2"; shift 2 ;;
    --wall-ms) WALL="$2"; shift 2 ;;
    --input-tokens) IN_TOK="$2"; shift 2 ;;
    --output-tokens) OUT_TOK="$2"; shift 2 ;;
    --model) MODEL="$2"; shift 2 ;;
    --agents) AGENTS="$2"; shift 2 ;;
    --result) RESULT="$2"; shift 2 ;;
    --session) SESSION="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 2 ;;
  esac
done

[[ -n "$ISSUE" && -n "$FLOW" && -n "$STEP" ]] || {
  echo "metrics-record: --issue --flow --step required" >&2
  exit 2
}

METRICS_DIR="$PROJECT_ISSUES_DIR/metrics"
mkdir -p "$METRICS_DIR"
LEDGER="$METRICS_DIR/issue-runs.jsonl"

export MR_ISSUE="$ISSUE" MR_FLOW="$FLOW" MR_STEP="$STEP" MR_PROFILE="$PROFILE"
export MR_STARTED="$STARTED" MR_ENDED="$ENDED" MR_WALL="$WALL"
export MR_IN="$IN_TOK" MR_OUT="$OUT_TOK" MR_MODEL="$MODEL"
export MR_AGENTS="$AGENTS" MR_RESULT="$RESULT" MR_SESSION="$SESSION"
export MR_LEDGER="$LEDGER"

python3 - <<'PY'
import json, os
from datetime import datetime, timezone

def num(v):
    if v is None or v == "":
        return None
    try:
        return int(v)
    except ValueError:
        return None

started = os.environ.get("MR_STARTED") or None
ended = os.environ.get("MR_ENDED") or None
wall = num(os.environ.get("MR_WALL"))
if wall is None and started and ended:
    try:
        # accept YYYY-MM-DDTHH:MM or full ISO
        def parse(s):
            s = s.replace("Z", "+00:00")
            if len(s) == 16:
                s = s + ":00+00:00"
            return datetime.fromisoformat(s)
        wall = int((parse(ended) - parse(started)).total_seconds() * 1000)
    except Exception:
        wall = None
if not ended:
    ended = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M")

agents = [a.strip() for a in os.environ.get("MR_AGENTS", "").split(",") if a.strip()]
row = {
    "issue": int(os.environ["MR_ISSUE"]),
    "flow": os.environ["MR_FLOW"],
    "step": os.environ["MR_STEP"],
    "profile": os.environ.get("MR_PROFILE") or None,
    "started": started,
    "ended": ended,
    "wall_ms": wall,
    "input_tokens": num(os.environ.get("MR_IN")),
    "output_tokens": num(os.environ.get("MR_OUT")),
    "model": os.environ.get("MR_MODEL") or None,
    "agents": agents,
    "result": os.environ.get("MR_RESULT") or "ok",
    "session": os.environ.get("MR_SESSION") or None,
}
path = os.environ["MR_LEDGER"]
with open(path, "a", encoding="utf-8") as f:
    f.write(json.dumps(row, ensure_ascii=False) + "\n")
print(path)
PY

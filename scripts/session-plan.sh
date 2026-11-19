#!/usr/bin/env bash
# session-plan.sh — Build day/week delivery schedule + session prompts + plans.
# Output: .codex/sessions/<YYYY-MM-DD>/{schedule.md,session-N.md,session-N.plan.md}
#
# Usage:
#   session-plan.sh [--horizon day|week] [--ids 12,13] [--date YYYY-MM-DD]
#                   [--launch] [--parallel N] [--worktree] [--flow develop|develop-full]
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib-issues.sh"

HORIZON="day"
IDS=""
DATE="$(date +%Y-%m-%d)"
LAUNCH=0
PARALLEL=1
WORKTREE=0
FLOW_CMD="develop-full"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --horizon) HORIZON="$2"; shift 2 ;;
    --ids) IDS="$2"; shift 2 ;;
    --date) DATE="$2"; shift 2 ;;
    --launch) LAUNCH=1; shift ;;
    --parallel) PARALLEL="$2"; shift 2 ;;
    --worktree) WORKTREE=1; shift ;;
    --flow) FLOW_CMD="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: session-plan.sh [--horizon day|week] [--ids 12,13] [--launch] [--parallel N] [--worktree]" >&2
      exit 0 ;;
    *) echo "Unknown: $1" >&2; exit 2 ;;
  esac
done

OUT_DIR="$PROJECT_ISSUES_DIR/sessions/$DATE"
mkdir -p "$OUT_DIR"

export SP_DIR="$OUT_DIR" SP_HORIZON="$HORIZON" SP_IDS="$IDS" SP_DATE="$DATE"
export SP_FLOW="$FLOW_CMD" SP_ROOT="${FLOW_PROJECT_ROOT}"
export SP_MODE; SP_MODE="$(issues_mode)"
export SP_ISSUES="$PROJECT_ISSUES_FILE" SP_INDEX="$PROJECT_ISSUES_DIR/issues/index.md"
export SP_ISSUES_DIR="$PROJECT_ISSUES_DIR"

python3 - <<'PY'
import json, os, re, pathlib

out = pathlib.Path(os.environ["SP_DIR"])
horizon = os.environ["SP_HORIZON"]
ids_filter = [int(x) for x in os.environ.get("SP_IDS", "").split(",") if x.strip().isdigit()]
flow = os.environ["SP_FLOW"]
mode = os.environ["SP_MODE"]
root = os.environ["SP_ROOT"]
issues_dir = pathlib.Path(os.environ["SP_ISSUES_DIR"])

def parse_section(text):
    lines = text.splitlines()
    m = re.match(r"^###\s+(\d+)\.\s+(.*)$", lines[0] if lines else "")
    if not m:
        return None
    fields = {}
    for line in lines[1:]:
        mm = re.match(r"^- ([A-Za-z][A-Za-z ]*): ?(.*)$", line)
        if mm:
            fields[mm.group(1)] = mm.group(2).strip()
    return {
        "id": int(m.group(1)),
        "title": m.group(2).strip(),
        "status": fields.get("Status", ""),
        "type": fields.get("Type", ""),
        "severity": fields.get("Severity", ""),
        "location": fields.get("Location", "-"),
        "reviewers": fields.get("Reviewers", ""),
        "tests": fields.get("Tests", ""),
        "work_plan": fields.get("Work plan", ""),
        "suggested": fields.get("Suggested fix", ""),
        "body": text,
    }

def load_issues():
    items = []
    if mode == "hybrid":
        for p in sorted((issues_dir / "issues").glob("*.md")):
            if p.name == "index.md":
                continue
            it = parse_section(p.read_text(encoding="utf-8"))
            if it:
                items.append(it)
    else:
        text = pathlib.Path(os.environ["SP_ISSUES"]).read_text(encoding="utf-8")
        for part in re.split(r"(?m)(?=^### [0-9]+\. )", text):
            if not part.startswith("### "):
                continue
            it = parse_section(part.strip() + "\n")
            if it:
                items.append(it)
    return items

def effort_hours(it):
    blob = f"{it.get('suggested','')} {it.get('work_plan','')}"
    m = re.search(r"~(\d+)(?:-(\d+))?h", blob)
    if m:
        return int(m.group(2) or m.group(1))
    if it["type"] in ("doc", "chore"):
        return 1
    if it["severity"] in ("critical", "high"):
        return 8
    return 4

def paths(loc):
    if not loc or loc == "-":
        return set()
    return {p.strip().split(":")[0] for p in loc.split(",") if p.strip()}

all_items = load_issues()
ready = [i for i in all_items if i["status"] == "ready"]
if ids_filter:
    ready = [i for i in ready if i["id"] in ids_filter] or [
        i for i in all_items if i["id"] in ids_filter
    ]

# Sort by effort
ready.sort(key=effort_hours)

# Greedy pack into sessions: conflict if location overlap
sessions = []
remaining = list(ready)
while remaining:
    seed = remaining.pop(0)
    group = [seed]
    used = paths(seed["location"])
    hours = effort_hours(seed)
    limit = 8 if horizon == "day" else 20
    still = []
    for it in remaining:
        p = paths(it["location"])
        conflict = bool(used & p) if p and used else False
        # schema/migrations always conflict with each other
        if any("schema" in x or "migration" in x for x in (used | p)):
            if p & used or any("schema" in x or "migration" in x for x in p):
                conflict = True
        if conflict or hours + effort_hours(it) > limit:
            still.append(it)
            continue
        group.append(it)
        used |= p
        hours += effort_hours(it)
    remaining = still
    sessions.append({"issues": group, "hours": hours, "paths": sorted(used)})

# Mark parallel-safe sessions (no path overlap across sessions)
sched_lines = [
    f"# Delivery schedule — {os.environ['SP_DATE']}",
    "",
    f"- Horizon: `{horizon}`",
    f"- Flow: `${flow}`",
    f"- Sessions: {len(sessions)}",
    "",
    "## Order",
    "",
]
for i, s in enumerate(sessions, 1):
    ids = ", ".join(f"#{x['id']}" for x in s["issues"])
    titles = "; ".join(x["title"][:60] for x in s["issues"])
    parallel = "PARALLEL-OK" if i > 1 else "START"
    # Check vs previous sessions' paths
    prev_paths = set()
    for j in range(i - 1):
        prev_paths |= set(sessions[j]["paths"])
    if set(s["paths"]) & prev_paths:
        parallel = "CONFLICT-seq"
    else:
        parallel = "PARALLEL-OK"
    sched_lines.append(
        f"{i}. **Session {i}** `{parallel}` ~{s['hours']}h — {ids} — {titles}"
    )
    if s["paths"]:
        sched_lines.append(f"   - paths: {', '.join(s['paths'][:8])}")
sched_lines.append("")
sched_lines.append("_Generated by `session-plan.sh`. Re-run after reindex if tracker conflicted._")
sched_lines.append("")
(out / "schedule.md").write_text("\n".join(sched_lines), encoding="utf-8")

manifest = []
for i, s in enumerate(sessions, 1):
    ids = [x["id"] for x in s["issues"]]
    bodies = "\n\n---\n\n".join(x["body"].rstrip() for x in s["issues"])
    plans = []
    for x in s["issues"]:
        wp = x.get("work_plan") or x.get("suggested") or "(derive from Tests + Suggested fix)"
        plans.append(f"### #{x['id']} {x['title']}\n{wp}\n")
    prompt = "\n".join(
        [
            f"# Session {i} — {os.environ['SP_DATE']}",
            "",
            f"Project: `{root}`",
            f"Command: `${flow} {' '.join(str(x) for x in ids)}`",
            "",
            "## Issues",
            "",
            bodies,
            "",
            "## Instructions",
            "",
            f"1. Run `${flow}` for each id in order: {', '.join('#'+str(x) for x in ids)}.",
            "2. Do not start issues marked CONFLICT with another live session.",
            "3. On index.md git conflict: `bash ~/.codex/flow/scripts/issues-reindex.sh`.",
            "4. Record metrics via metrics-record.sh after major steps.",
            "",
        ]
    )
    plan = "\n".join(
        [
            f"# Session {i} plan — {os.environ['SP_DATE']}",
            "",
            f"- Hours (est): {s['hours']}",
            f"- Paths: {', '.join(s['paths']) or '—'}",
            f"- Reviewers: follow each issue `Reviewers:` + delivery-route.sh",
            "",
            "## Work plans",
            "",
            *plans,
            "## Gates",
            "",
            "- test-runner.sh --run",
            "- committer-check.sh <id>",
            "- create-pr.sh <id>",
            "",
        ]
    )
    (out / f"session-{i}.md").write_text(prompt, encoding="utf-8")
    (out / f"session-{i}.plan.md").write_text(plan, encoding="utf-8")
    manifest.append({"session": i, "ids": ids, "hours": s["hours"], "paths": s["paths"]})

(out / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(str(out))
print(f"sessions={len(sessions)} issues={sum(len(s['issues']) for s in sessions)}")
PY

echo "[session-plan] wrote $OUT_DIR"

if [[ "$LAUNCH" -eq 1 ]]; then
  MANIFEST="$OUT_DIR/manifest.json"
  [[ -f "$MANIFEST" ]] || exit 1
  BASE_BRANCH=$(git -C "$FLOW_PROJECT_ROOT" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##' || echo main)
  WT_ROOT="$(dirname "$FLOW_PROJECT_ROOT")/.flow-worktrees"
  running=0
  n_sessions=$(python3 -c "import json; print(len(json.load(open('$MANIFEST'))))")
  for i in $(seq 1 "$n_sessions"); do
    while [[ "$running" -ge "$PARALLEL" ]]; do
      sleep 2
      running=$(jobs -pr | wc -l | tr -d ' ')
    done
    ids=$(python3 -c "import json; print(' '.join(map(str, json.load(open('$MANIFEST'))[$i-1]['ids'])))")
    workdir="$FLOW_PROJECT_ROOT"
    if [[ "$WORKTREE" -eq 1 ]]; then
      mkdir -p "$WT_ROOT"
      workdir="$WT_ROOT/session-$DATE-$i"
      if [[ ! -d "$workdir" ]]; then
        git -C "$FLOW_PROJECT_ROOT" worktree add -b "flow/session-$DATE-$i" "$workdir" "$BASE_BRANCH" 2>/dev/null \
          || git -C "$FLOW_PROJECT_ROOT" worktree add "$workdir" "$BASE_BRANCH"
      fi
    fi
    echo "[session-plan] launching session $i ids=[$ids] cwd=$workdir"
    (
      cd "$workdir"
      bash "$SCRIPTS_DIR/codex-run.sh" "$workdir" "$FLOW_CMD" $ids
    ) &
    running=$((running + 1))
  done
  wait || true
  if command -v bash >/dev/null && [[ -x "$SCRIPTS_DIR/flow-notify.sh" ]]; then
    bash "$SCRIPTS_DIR/flow-notify.sh" "session-plan: finished $n_sessions session(s) for $DATE" || true
  fi
fi

#!/usr/bin/env bash
# delivery-route.sh — After implement, decide which senior reviewers to run.
# Usage: delivery-route.sh <issue-id>
# Requires a git checkout with a Base branch on the issue. Prints JSON.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib-issues.sh"

ID="${1:-}"
[[ "$ID" =~ ^[0-9]+$ ]] || { echo "Usage: delivery-route.sh <issue-id>" >&2; exit 2; }

SECTION="$(issue_section "$ID" || true)"
[[ -n "$SECTION" ]] || { echo "issue $ID not found" >&2; exit 2; }

field() {
  printf '%s\n' "$SECTION" | awk -v f="$1" '
    $0 ~ "^- " f ":" {cap=1; sub("^- " f ": ?","",$0); print; next}
    cap && /^- [A-Za-z]/ {cap=0}
    cap {print}
  '
}
val() { field "$1" | sed -n 1p | sed 's/^[[:space:]]*//'; }

TYPE=$(val "Type")
SEVERITY=$(val "Severity")
FLOW=$(val "Flow")
REVIEWERS=$(val "Reviewers")
BASE=$(val "Base branch")
LOCATION=$(val "Location")
TITLE=$(printf '%s\n' "$SECTION" | sed -n '1s/^### [0-9]*\. //p')

if [[ -z "$BASE" || "$BASE" == "-" ]]; then
  BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##' || true)
  BASE="${BASE:-main}"
fi

# Parse "N (a, b, c)"
PROFILES=()
if [[ "$REVIEWERS" =~ ^([0-9]+)[[:space:]]*\((.+)\)$ ]]; then
  FLOOR="${BASH_REMATCH[1]}"
  IFS=',' read -r -a raw_profiles <<< "${BASH_REMATCH[2]}"
  for p in "${raw_profiles[@]}"; do
    p=$(echo "$p" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [[ -n "$p" ]] && PROFILES+=("$p")
  done
else
  FLOOR=1
  PROFILES=(backend)
fi

# Loop floor overrides
case "$TYPE/$SEVERITY" in
  bug/critical|bug/high) [[ "$FLOOR" -lt 2 ]] && FLOOR=2 ;;
esac
if [[ "$FLOW" == "lean" && "$TYPE" == "bug" && "$SEVERITY" =~ ^(low|medium)$ ]]; then
  [[ "$FLOOR" -lt 1 ]] && FLOOR=1
fi

DEV_AGENT=$("$SCRIPTS_DIR/detect-lang.sh" "${LOCATION:-}" 2>/dev/null || echo "development/developer")
# TS/tsx Location override (mirrors develop-full skill)
if [[ -n "$LOCATION" ]] && printf '%s' "$LOCATION" | grep -qE '\.tsx?(\s|$|,)' \
  && ! printf '%s' "$LOCATION" | grep -qE '\.(go|py)(\s|$|,)'; then
  DEV_AGENT="development/developer"
fi

export DR_ID="$ID" DR_BASE="$BASE" DR_FLOOR="$FLOOR" DR_TYPE="$TYPE" \
  DR_SEVERITY="$SEVERITY" DR_FLOW="$FLOW" DR_DEV="$DEV_AGENT" DR_TITLE="$TITLE"
export DR_PROFILES
DR_PROFILES=$(printf '%s\n' "${PROFILES[@]}")

PREFLIGHT="$SCRIPTS_DIR/review-preflight.sh"
export DR_PREFLIGHT="$PREFLIGHT"

python3 - <<'PY'
import json, os, re, subprocess

profiles = [p for p in os.environ.get("DR_PROFILES", "").splitlines() if p.strip()]
floor = int(os.environ.get("DR_FLOOR", "1"))
base = os.environ["DR_BASE"]
issue_id = os.environ["DR_ID"]
preflight = os.environ["DR_PREFLIGHT"]
itype = os.environ.get("DR_TYPE", "")
severity = os.environ.get("DR_SEVERITY", "")

# Changed files vs base
try:
    diff = subprocess.check_output(
        ["git", "diff", "--name-only", f"{base}...HEAD"],
        text=True,
        stderr=subprocess.DEVNULL,
    )
except subprocess.CalledProcessError:
    try:
        diff = subprocess.check_output(
            ["git", "diff", "--name-only", base],
            text=True,
            stderr=subprocess.DEVNULL,
        )
    except subprocess.CalledProcessError:
        diff = ""
changed = [f for f in diff.splitlines() if f.strip()]

# Profile globs (keep in sync with review-preflight.sh)
GLOBS = {
    "backend": [r"\.go$", r"\.py$", r"\.rb$", r"/handlers/", r"/controllers/"],
    "frontend": [r"\.tsx?$", r"\.jsx?$", r"\.vue$", r"\.css$", r"\.scss$"],
    "data": [r"\.sql$", r"migrations/", r"schemas/"],
    "security": [r"auth/", r"middleware/", r"/security/", r"\.env", r"Dockerfile"],
    "runtime": [r"Dockerfile", r"docker-compose", r"\.github/workflows/", r"deploy/", r"k8s/"],
    "devops": [r"\.github/", r"\bci/", r"scripts/", r"Makefile"],
    "performance": [r"\.go$", r"\.py$", r"\.tsx?$", r"cache/", r"perf/"],
    "ux-ui": [r"\.tsx?$", r"\.jsx?$", r"\.html$", r"\.css$"],
    "qa": [r"_test\.", r"/tests/", r"/spec/"],
    "mobile": [r"\.swift$", r"\.kt$", r"android/", r"ios/"],
    "auth": [r"auth/", r"/auth/", r"middleware/"],
}

def match_count(profile: str) -> int:
    pats = GLOBS.get(profile, [])
    if not pats:
        return len(changed)  # unknown profile → keep
    n = 0
    for f in changed:
        for pat in pats:
            if re.search(pat, f):
                n += 1
                break
    return n

mandatory = set()
if itype == "bug" and severity in ("critical", "high"):
    mandatory.update(profiles[:2] if len(profiles) >= 2 else profiles)
if any(p in profiles for p in ("security", "auth")):
    if match_count("security") or match_count("auth") or severity in ("critical", "high"):
        if "security" in profiles:
            mandatory.add("security")
        if "auth" in profiles:
            mandatory.add("auth")

to_run = []
skipped = []
for p in profiles:
    n = match_count(p)
    # Always run preflight for evidence (best-effort)
    try:
        subprocess.run([preflight, issue_id, p], check=False, capture_output=True)
    except Exception:
        pass
    if p in mandatory or n > 0:
        to_run.append({"profile": p, "matched_files": n, "mandatory": p in mandatory})
    else:
        skipped.append({"profile": p, "reason": "no matching files", "matched_files": 0})

# Enforce floor
while len(to_run) < floor and skipped:
    moved = skipped.pop(0)
    to_run.append(
        {
            "profile": moved["profile"],
            "matched_files": moved.get("matched_files", 0),
            "mandatory": True,
            "forced_for_floor": True,
        }
    )
if not to_run and profiles:
    to_run.append({"profile": profiles[0], "matched_files": 0, "mandatory": True, "forced_for_floor": True})

out = {
    "issue": int(issue_id),
    "title": os.environ.get("DR_TITLE", ""),
    "type": itype,
    "severity": severity,
    "flow": os.environ.get("DR_FLOW", ""),
    "floor": floor,
    "base_branch": base,
    "dev_agent": os.environ.get("DR_DEV", "development/developer"),
    "changed_files": len(changed),
    "reviewers_to_run": [x["profile"] for x in to_run],
    "reviewers_detail": to_run,
    "reviewers_skipped": skipped,
    "max_rereview_cycles": 2,
}
print(json.dumps(out, ensure_ascii=False, indent=2))
PY

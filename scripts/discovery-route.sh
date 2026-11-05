#!/usr/bin/env bash
# discovery-route.sh — Classify a discovery proposal and list judgment agents.
# Usage: discovery-route.sh [--text FILE|-] [--type TYPE] [--severity SEV]
# Prints JSON: loop, agents[], defaults, gate_failures[], risk_triggers[]
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

TEXT=""
TYPE=""
SEVERITY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --text) TEXT="${2:-}"; shift 2 ;;
    --type) TYPE="${2:-}"; shift 2 ;;
    --severity) SEVERITY="${2:-}"; shift 2 ;;
    -h|--help)
      echo "Usage: discovery-route.sh [--text FILE|-] [--type TYPE] [--severity SEV]" >&2
      exit 0 ;;
    *) echo "Unknown flag: $1" >&2; exit 2 ;;
  esac
done

if [[ -z "$TEXT" || "$TEXT" == "-" ]]; then
  if [[ -t 0 ]]; then
    echo "discovery-route: pass --text FILE or pipe the proposal on stdin" >&2
    exit 2
  fi
  PROPOSAL=$(cat)
elif [[ -f "$TEXT" ]]; then
  PROPOSAL=$(cat "$TEXT")
else
  PROPOSAL="$TEXT"
fi

export DR_TYPE="$TYPE" DR_SEVERITY="$SEVERITY" DR_PROPOSAL="$PROPOSAL"
export DR_DETECT="$SCRIPTS_DIR/detect-lang.sh"

python3 - <<'PY'
import json, os, re, subprocess

proposal = os.environ.get("DR_PROPOSAL", "")
type_hint = (os.environ.get("DR_TYPE") or "").strip().lower()
sev_hint = (os.environ.get("DR_SEVERITY") or "").strip().lower()
low = proposal.lower()

def has_rules(text: str) -> bool:
    if re.search(r"(?i)business\s*rules?\s*:", text):
        body = re.split(r"(?i)business\s*rules?\s*:", text, maxsplit=1)[1]
        body = re.split(r"(?i)^-\s*[A-Za-z].*:|\n#{1,3}\s", body, maxsplit=1)[0]
        lines = [ln.strip() for ln in body.splitlines() if ln.strip() and ln.strip() != "-"]
        if any(ln.lower() not in ("none", "-") for ln in lines):
            return True
    # Heuristic: numbered/bulleted constraints when user pastes a full brief
    bullets = re.findall(r"(?m)^\s*(?:[-*]|\d+[.)])\s+\S.{15,}", text)
    return len(bullets) >= 3 and bool(
        re.search(r"(?i)\b(must|shall|deve|regra|aceite|acceptance|quando|if\b)", text)
    )

def test_count(text: str) -> int:
    m = re.search(r"(?i)(?:^|\n)-\s*Tests?\s*:(.*)", text, re.S)
    block = m.group(1) if m else text
    if m:
        block = re.split(r"(?i)\n-\s*[A-Za-z].*?:", block, maxsplit=1)[0]
    scenarios = re.findall(r"(?i)(?:→|->|=>|\bthen\b|\bentão\b)", block)
    if scenarios:
        return len(scenarios)
    bullets = re.findall(r"(?m)^\s*(?:[-*]|\d+[.)])\s+\S.{8,}", block if m else "")
    return len(bullets)

def infer_type() -> str:
    if type_hint in ("bug", "feat", "doc", "chore"):
        return type_hint
    if re.search(r"(?i)\b(bug|defect|regression|quebra|falha|crash|hotfix)\b", low):
        return "bug"
    if re.search(r"(?i)\b(chore|docs?|documentation|readme|typo)\b", low) and not re.search(
        r"(?i)\b(feat|feature|add|nova|novo)\b", low
    ):
        if re.search(r"(?i)\bdocs?\b", low):
            return "doc"
        return "chore"
    return "feat"

def infer_severity() -> str:
    if sev_hint in ("critical", "high", "medium", "low"):
        return sev_hint
    if re.search(r"(?i)\b(critical|blocker|sev(erity)?\s*[:=]?\s*critical)\b", low):
        return "critical"
    if re.search(r"(?i)\b(high|sev(erity)?\s*[:=]?\s*high|p0|p1)\b", low):
        return "high"
    if re.search(r"(?i)\b(low|sev(erity)?\s*[:=]?\s*low|p3)\b", low):
        return "low"
    return "medium"

def risk_triggers(text: str) -> list[str]:
    triggers = []
    checks = [
        ("auth", r"(?i)\b(auth|oauth|jwt|session|login|rbac|permission)\b"),
        ("security", r"(?i)\b(security|xss|csrf|injection|secret|credential|encrypt)\b"),
        ("multi-service", r"(?i)\b(microservice|multi[- ]service|cross[- ]cutting|gateway)\b"),
        ("architecture", r"(?i)\b(architecture|standards?|adr|refactor\s+core|migrate\s+schema)\b"),
        ("sensitive-data", r"(?i)\b(pii|lgpd|gdpr|payment|pci|health)\b"),
    ]
    for name, pat in checks:
        if re.search(pat, text):
            triggers.append(name)
    return triggers

itype = infer_type()
severity = infer_severity()
rules_ok = has_rules(proposal)
tests_n = test_count(proposal)
floor = {"critical": 3, "high": 3, "medium": 2, "low": 1}.get(severity, 2)
risks = risk_triggers(proposal)
gate_failures = []
agents = []
loop = ""

try:
    detect = subprocess.check_output(
        [os.environ["DR_DETECT"]], text=True, stderr=subprocess.DEVNULL
    ).strip()
except Exception:
    detect = "development/developer"

if "golang" in detect:
    default_reviewer = "1 (backend)"
elif "python" in detect:
    default_reviewer = "1 (backend)"
else:
    default_reviewer = "1 (backend)"

if itype in ("doc", "chore"):
    loop = "chore"
    agents = []
elif itype == "bug":
    if severity in ("critical", "high"):
        loop = "bug-expedite"
        agents = ["development/product-owner"]
        if "security" in risks or "auth" in risks or "sensitive-data" in risks:
            default_reviewer = "2 (backend, security)"
        else:
            default_reviewer = "2 (backend, qa)"
    else:
        loop = "bug-lean"
        agents = ["development/product-owner"]
        default_reviewer = "1 (backend)"
        if "security" in risks or "auth" in risks:
            default_reviewer = "1 (security)"
elif itype == "feat":
    if not rules_ok:
        gate_failures.append("business-rules-missing")
    if tests_n < floor:
        gate_failures.append(f"tests-below-floor:{tests_n}<{floor}")
    if risks:
        gate_failures.append("risk:" + ",".join(risks))
    if not gate_failures:
        loop = "feat-lean"
        agents = []
    else:
        loop = "feat-full"
        if "business-rules-missing" in gate_failures or any(
            g.startswith("tests-below-floor") for g in gate_failures
        ):
            agents.append("development/product-owner")
        if any(g.startswith("risk:") for g in gate_failures):
            if any(t in risks for t in ("architecture", "multi-service")):
                agents.append("development/cto")
            agents.append("development/tech-lead")
        elif "business-rules-missing" in gate_failures or any(
            g.startswith("tests-below-floor") for g in gate_failures
        ):
            # Still need branch/reviewers unless fully specified in text
            if not re.search(r"(?i)base\s*branch\s*:", proposal) or not re.search(
                r"(?i)reviewers\s*:", proposal
            ):
                agents.append("development/tech-lead")
        # Deduplicate preserving order
        seen = set()
        agents = [a for a in agents if not (a in seen or seen.add(a))]
else:
    loop = "feat-full"
    agents = ["development/product-owner", "development/tech-lead"]
    gate_failures.append("unknown-type")

out = {
    "loop": loop,
    "type": itype,
    "severity": severity,
    "agents": agents,
    "defaults": {
        "base_branch": "",
        "reviewers": default_reviewer,
        "status": "ready",
        "dev_agent": detect,
    },
    "gate_failures": gate_failures,
    "risk_triggers": risks,
    "tests_found": tests_n,
    "tests_floor": floor if itype not in ("doc", "chore") else 0,
    "rules_ok": rules_ok,
}
print(json.dumps(out, ensure_ascii=False, indent=2))
PY

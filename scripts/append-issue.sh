#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/lib-issues.sh"
source "$(dirname "$0")/lib-os.sh"

# Usage: append-issue.sh [flags]
#
# Appends a CANONICAL issue entry (hybrid issues/<id>.md or monolith
# known_issues.md) using the schema from standards/issues.md.
#
# Flags: --id --title --type --severity --priority --base --reviewers
#   --location --description --impact --business-rules --acceptance
#   --tests --work-plan --flow --report --status --no-lint

decode() { printf '%s' "${1:-}" | sed 's/\\n/\n/g'; }

ID=""
TITLE=""; TYPE="feat"; SEVERITY="medium"; PRIORITY="medium"
BASE="-"; REVIEWERS="1 (backend)"; LOCATION="-"
DESCRIPTION=""; IMPACT=""; BUS="-"; ACCEPTANCE=""; TESTS="-"
WORK_PLAN=""; FLOW=""; REPORT="model"; STATUS="backlog"; LINT=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) ID="$2"; shift 2 ;;
    --title) TITLE="$2"; shift 2 ;;
    --type) TYPE="$2"; shift 2 ;;
    --severity) SEVERITY="$2"; shift 2 ;;
    --priority) PRIORITY="$2"; shift 2 ;;
    --base) BASE="$2"; shift 2 ;;
    --reviewers) REVIEWERS="$2"; shift 2 ;;
    --location) LOCATION="$2"; shift 2 ;;
    --description) DESCRIPTION="$2"; shift 2 ;;
    --impact) IMPACT="$2"; shift 2 ;;
    --business-rules) BUS="$2"; shift 2 ;;
    --acceptance) ACCEPTANCE="$2"; shift 2 ;;
    --tests) TESTS="$2"; shift 2 ;;
    --work-plan) WORK_PLAN="$2"; shift 2 ;;
    --flow) FLOW="$2"; shift 2 ;;
    --report) REPORT="$2"; shift 2 ;;
    --status) STATUS="$2"; shift 2 ;;
    --no-lint) LINT=0; shift ;;
    *) echo "Unknown flag: $1"; exit 3 ;;
  esac
done

if [[ -z "$TITLE" ]]; then echo "append-issue: --title required"; exit 3; fi
FILE="$PROJECT_ISSUES_FILE"
MODE="$(issues_mode)"
if [[ "$MODE" == monolith && ! -f "$FILE" ]]; then
  echo "known_issues.md not found"; exit 3
fi
if [[ "$MODE" == hybrid ]]; then
  mkdir -p "$PROJECT_ISSUES_DIR/issues"
fi

flow_lock_begin "$PROJECT_ISSUES_DIR/.issues.lock"

if [[ -z "$ID" ]]; then
  ID=$(( $(issues_max_id) + 1 ))
fi
[[ "$ID" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue ID"; exit 3; }

if issue_path "$ID" >/dev/null 2>&1; then
  echo "Issue $ID already exists (active or archived)"; exit 3
fi

FLOW_LINE=""
if [[ -n "$FLOW" && "$FLOW" != "-" ]]; then
  FLOW_LINE=$'\n'"- Flow: $FLOW"
fi
WP_LINE=""
if [[ -n "$WORK_PLAN" && "$WORK_PLAN" != "-" ]]; then
  WP_LINE=$'\n'"- Work plan: $(decode "$WORK_PLAN")"
fi

BODY=$(cat <<EOF
### $ID. $(decode "$TITLE")
- Status: $STATUS
- Type: $TYPE
- Severity: $SEVERITY
- Priority: $PRIORITY$FLOW_LINE
- Report: $REPORT
- Base branch: $BASE
- Reviewers: $REVIEWERS
- Remote: -
- Jira: -
- PR: -
- Location: $LOCATION
- Description: $(decode "$DESCRIPTION")
- Impact: $(decode "$IMPACT")
- Business rules: $(decode "$BUS")
- Acceptance criteria: $(decode "$ACCEPTANCE")
- Tests: $(decode "$TESTS")$WP_LINE
- Suggested fix: -
EOF
)

BACKUP=""
if [[ "$MODE" == hybrid ]]; then
  DEST="$(issue_write_body "$ID" <<<"$BODY")"
  bash "$SCRIPTS_DIR/issues-reindex.sh" >/dev/null
  BACKUP="$DEST"
else
  BACKUP=$(mktemp "$PROJECT_ISSUES_DIR/.append.XXXXXX")
  cp "$FILE" "$BACKUP"
  trap 'rm -f "$BACKUP"' EXIT
  printf '\n%s\n' "$BODY" >> "$FILE"
fi

echo "[append] issue $ID appended (status=$STATUS mode=$MODE)"

if [[ "$LINT" -eq 1 ]]; then
  if ! "$SCRIPTS_DIR/issue-lint.sh" "$ID"; then
    if [[ "$MODE" == hybrid ]]; then
      rm -f "$DEST"
      bash "$SCRIPTS_DIR/issues-reindex.sh" >/dev/null
    else
      cp "$BACKUP" "$FILE"
    fi
    echo "append-issue: lint failed; tracker restored"
    exit 2
  fi
fi

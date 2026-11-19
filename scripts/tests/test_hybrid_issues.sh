#!/usr/bin/env bash
# test_hybrid_issues.sh — migrate → append → transition → reindex (hybrid).
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib.sh"
t_begin "test_hybrid_issues"

MIG="$HERE/../issues-migrate.sh"
REIDX="$HERE/../issues-reindex.sh"
APPEND="$HERE/../append-issue.sh"
TRANS="$HERE/../transition.sh"
PATHSH="$HERE/../issue-path.sh"
SESSION="$HERE/../session-plan.sh"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cd "$TMP"
git init -q
git config user.email "t@example.com"
git config user.name "T"
mkdir -p .codex

cat >.codex/known_issues.md <<'EOF'
## Known Issues

### 1. Ready feature A
- Status: ready
- Type: feat
- Severity: medium
- Priority: medium
- Report: model
- Base branch: main
- Reviewers: 1 (backend)
- Remote: -
- Jira: -
- PR: -
- Location: src/a.go
- Description: export
- Impact: ops
- Business rules: Only admins
- Acceptance criteria: CSV works
- Tests:
  - Admin → CSV
  - Non-admin → 403
- Work plan:
  - Add handler → returns CSV
  - Add test → covers 403
- Suggested fix: ~2h

### 2. Ready feature B
- Status: ready
- Type: feat
- Severity: low
- Priority: low
- Report: model
- Base branch: main
- Reviewers: 1 (backend)
- Remote: -
- Jira: -
- PR: -
- Location: src/b.go
- Description: other
- Impact: ops
- Business rules: Public ok
- Acceptance criteria: done
- Tests:
  - Ok → 200
- Work plan: Implement B → green
- Suggested fix: ~1h
EOF
touch .codex/resolved_issues.md

bash "$MIG" --keep-monolith
[[ -f .codex/issues/index.md ]] && t_ok "index created" || t_fail "index created"
[[ -f .codex/issues/001.md ]] && t_ok "body 001" || t_fail "body 001"

P=$(bash "$PATHSH" 1 2>/dev/null | head -n1)
[[ "$P" == *"/issues/001.md" ]] && t_ok "issue-path hybrid" || t_fail "issue-path hybrid ($P)"

bash "$TRANS" 1 in-progress
grep -q 'Status: in-progress' .codex/issues/001.md && t_ok "transition hybrid" || t_fail "transition hybrid"
bash "$REIDX" >/dev/null
grep -q 'in-progress' .codex/issues/index.md && t_ok "reindex status" || t_fail "reindex status"

bash "$APPEND" --title "New hybrid" --type chore --severity low --tests "-" --status backlog --no-lint
[[ -f .codex/issues/003.md ]] && t_ok "append hybrid id 3" || t_fail "append hybrid id 3"

# session-plan from ready (#2 still ready)
bash "$SESSION" --horizon day --ids 2 >/dev/null
[[ -f .codex/sessions/$(date +%Y-%m-%d)/schedule.md ]] && t_ok "session schedule" || t_fail "session schedule"
[[ -f .codex/sessions/$(date +%Y-%m-%d)/session-1.plan.md ]] && t_ok "session plan always" || t_fail "session plan always"

t_finish

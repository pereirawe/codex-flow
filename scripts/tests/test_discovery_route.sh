#!/usr/bin/env bash
# test_discovery_route.sh — feat-lean / feat-full / bug / chore routing.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib.sh"
t_begin "test_discovery_route"

ROUTE="$HERE/../discovery-route.sh"
[[ -f "$ROUTE" ]] || { t_fail "discovery-route.sh missing"; t_finish; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

json_field() {
  python3 -c 'import json,sys; d=json.load(sys.stdin); print(d'"$1"')'
}

# feat-lean: rules + tests, no risk → agents=[]
cat >"$TMP/lean.txt" <<'EOF'
Add CSV export for invoices.

Business rules:
- Only admins can export
- Export includes paid invoices only
- Max 10k rows per file

- Type: feat
- Severity: medium
- Tests:
  - Admin requests export → CSV with paid rows
  - Non-admin requests export → 403
EOF

OUT=$(bash "$ROUTE" --text "$TMP/lean.txt" --type feat --severity medium)
loop=$(printf '%s' "$OUT" | json_field "['loop']")
agents=$(printf '%s' "$OUT" | json_field "['agents']")
assert_eq "feat-lean" "$loop" "lean loop"
assert_eq "[]" "$agents" "lean agents empty"

# feat-full: missing rules → product-owner
cat >"$TMP/norules.txt" <<'EOF'
Add dark mode toggle for the settings page.
- Severity: medium
- Tests:
  - User toggles dark → UI switches theme
  - Preference persists → reload keeps theme
EOF

OUT=$(bash "$ROUTE" --text "$TMP/norules.txt" --type feat --severity medium)
loop=$(printf '%s' "$OUT" | json_field "['loop']")
assert_eq "feat-full" "$loop" "missing rules → feat-full"
printf '%s' "$OUT" | grep -q 'development/product-owner' && t_ok "PO when rules missing" || t_fail "PO when rules missing"

# feat-full: auth risk → tech-lead
cat >"$TMP/risk.txt" <<'EOF'
Add OAuth login with Google.

Business rules:
- Users must verify email before first login
- Sessions expire after 24h
- Refresh tokens rotate on use

- Type: feat
- Severity: high
- Tests:
  - Valid Google token → session created
  - Unverified email → blocked
  - Expired session → 401
EOF

OUT=$(bash "$ROUTE" --text "$TMP/risk.txt" --type feat --severity high)
loop=$(printf '%s' "$OUT" | json_field "['loop']")
assert_eq "feat-full" "$loop" "auth risk → feat-full"
printf '%s' "$OUT" | grep -q 'development/tech-lead' && t_ok "TL on auth risk" || t_fail "TL on auth risk"

# bug high → bug-expedite + PO
OUT=$(bash "$ROUTE" --type bug --severity high --text "Critical crash on checkout payment null pointer")
loop=$(printf '%s' "$OUT" | json_field "['loop']")
assert_eq "bug-expedite" "$loop" "bug high expedite"

# chore → no agents
OUT=$(bash "$ROUTE" --type chore --severity low --text "Update README typo in install section")
loop=$(printf '%s' "$OUT" | json_field "['loop']")
agents=$(printf '%s' "$OUT" | json_field "['agents']")
assert_eq "chore" "$loop" "chore loop"
assert_eq "[]" "$agents" "chore agents empty"

# tests below floor
cat >"$TMP/fewtests.txt" <<'EOF'
Add newsletter signup.

Business rules:
- Email must be unique
- Double opt-in required

- Type: feat
- Severity: medium
- Tests:
  - Valid email → pending confirmation
EOF

OUT=$(bash "$ROUTE" --text "$TMP/fewtests.txt" --type feat --severity medium)
printf '%s' "$OUT" | grep -q 'tests-below-floor' && t_ok "tests floor gate" || t_fail "tests floor gate"
loop=$(printf '%s' "$OUT" | json_field "['loop']")
assert_eq "feat-full" "$loop" "few tests → feat-full"

t_finish

#!/usr/bin/env bash
# test_delivery_route.sh — prune reviewers without matching files; keep floor.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib.sh"
t_begin "test_delivery_route"

ROUTE="$HERE/../delivery-route.sh"
[[ -f "$ROUTE" ]] || { t_fail "delivery-route.sh missing"; t_finish; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
git init -q
git config user.email "test@example.com"
git config user.name "Test"
mkdir -p .codex src

cat >.codex/known_issues.md <<'EOF'
## Known Issues

### 7. Add invoice CSV export
- Status: in-review
- Type: feat
- Severity: medium
- Priority: P2
- Flow: full
- Base branch: main
- Location: src/export.go
- Reviewers: 1 (backend, frontend, data)
- Remote: -
EOF

echo 'package main' > src/export.go
git add -A
git commit -q -m "base"
git branch -M main

git checkout -q -b issue-7-export
echo '// export' >> src/export.go
git add -A
git commit -q -m "export"

OUT=$(bash "$ROUTE" 7)
printf '%s\n' "$OUT" >"$TMP/out7.json"
printf '%s' "$OUT" | python3 -c '
import json,sys
d=json.load(sys.stdin)
run=set(d.get("reviewers_to_run",[]))
skipped={s["profile"] for s in d.get("reviewers_skipped",[])}
assert "backend" in run, d
assert "frontend" in skipped, d
assert "frontend" not in run
assert d.get("max_rereview_cycles") == 2
print("ok")
' && t_ok "backend kept; frontend pruned; cycles=2" || t_fail "backend kept; frontend pruned; cycles=2"

# Floor force: README-only change, floor 2 with frontend+data → force keep 2
cat >.codex/known_issues.md <<'EOF'
## Known Issues

### 8. Docs only tweak
- Status: in-review
- Type: feat
- Severity: medium
- Priority: P3
- Flow: lean
- Base branch: main
- Location: README.md
- Reviewers: 2 (frontend, data)
- Remote: -
EOF
echo '# hi' > README.md
git add -A
git commit -q -m "readme"

OUT=$(bash "$ROUTE" 8)
printf '%s' "$OUT" | python3 -c '
import json,sys
d=json.load(sys.stdin)
assert d["floor"] == 2, d
assert len(d["reviewers_to_run"]) >= 2, d
forced = [x for x in d["reviewers_detail"] if x.get("forced_for_floor")]
assert forced, d
print("ok")
' && t_ok "floor forces reviewers" || t_fail "floor forces reviewers"

t_finish

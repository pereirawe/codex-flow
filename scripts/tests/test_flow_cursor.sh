#!/usr/bin/env bash
# Resolver, steward ledger, and the Cursor/Codex notification split.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"
t_begin "test_flow_cursor"

RESOLVE="$ROOT/scripts/flow-resolve.py"
STEWARD="$ROOT/scripts/flow-steward.sh"
NOTIFY="$ROOT/scripts/flow-notify.sh"

discovery="$(python3 "$RESOLVE" command discovery)"
assert_eq "$(realpath "$ROOT/command-skills/discovery/SKILL.md")" "$discovery" "resolve discovery"

agent="$(python3 "$RESOLVE" agent development/discovery)"
assert_eq "$(realpath "$ROOT/agents/development/discovery.md")" "$agent" "resolve discovery agent"

if python3 "$RESOLVE" skill does-not-exist >/dev/null 2>&1; then
  t_fail "unknown skill must fail"
else
  t_ok "unknown skill fails"
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
export FLOW_STEWARD_LEDGER="$tmp/ledger.jsonl"

"$STEWARD" record --flow discovery --step 4 --result fix --class lint-path \
  --note "call issue-lint with the project tracker" >/dev/null
assert_contains "$tmp/ledger.jsonl" '"class": "lint-path"' "ledger records the class"

lessons="$("$STEWARD" lessons --flow discovery)"
assert_eq "fix lint-path: call issue-lint with the project tracker" "$lessons" "lessons prints the fix"
other="$("$STEWARD" lessons --flow develop)"
assert_eq "" "$other" "other flows stay empty"

assert_contains "$NOTIFY" "telegram-notify.sh" "flow-notify tries Telegram first"
assert_contains "$NOTIFY" "openwa-notify.sh" "flow-notify falls back to OpenWA"
assert_contains "$NOTIFY" "exit 1" "flow-notify fails when both channels fail"
assert_contains "$ROOT/skills/shared/flow-steward/SKILL.md" "command-skills/<flow>/SKILL.md" "steward edits only the flow skill"
assert_contains "$ROOT/command-skills/discovery/SKILL.md" "flow-steward/SKILL.md" "discovery runs the steward"
assert_contains "$ROOT/command-skills/develop/SKILL.md" "flow-notify.sh" "develop notifies via flow-notify"
assert_contains "$ROOT/command-skills/develop-full/SKILL.md" "flow-steward/SKILL.md" "develop-full runs the steward"

t_finish

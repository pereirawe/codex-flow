#!/usr/bin/env bash
# run_all.sh — execute every test_*.sh in this directory and aggregate results.
#
# Usage: bash scripts/tests/run_all.sh   (or `make test-scripts`)
# Exit status is 0 only when every test file passes.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
files_passed=0
files_failed=0

tests=("$SCRIPT_DIR"/test_*.sh)
if [[ "${1:-}" == --core ]]; then
  tests=()
  for name in remote language issue_lint timestamps jira_sync committer_check test_runner; do
    tests+=("$SCRIPT_DIR/test_${name}.sh")
  done
fi
for t in "${tests[@]}"; do
  [[ -e "$t" ]] || continue
  chmod +x "$t" 2>/dev/null || true
  if bash "$t"; then
    files_passed=$((files_passed + 1))
    echo "[PASS] $(basename "$t")"
  else
    files_failed=$((files_failed + 1))
    echo "[FAIL] $(basename "$t")"
  fi
  echo ""
done

echo "=== test-scripts: $((files_passed + files_failed)) file(s), $files_failed failed ==="
[[ "$files_failed" -eq 0 ]]

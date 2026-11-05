#!/usr/bin/env bash
# issue-path.sh — Print canonical path for an issue id (hybrid or monolith).
# Usage: issue-path.sh <id> [--section]
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib-issues.sh"

ID="${1:-}"
MODE="${2:-}"
[[ "$ID" =~ ^[0-9]+$ ]] || { echo "Usage: issue-path.sh <id> [--section]" >&2; exit 2; }

if [[ "$MODE" == "--section" ]]; then
  issue_section "$ID" || { echo "issue $ID not found" >&2; exit 1; }
  exit 0
fi

path="$(issue_path "$ID")" || { echo "issue $ID not found" >&2; exit 1; }
echo "$path"
echo "mode=$(issues_mode)" >&2

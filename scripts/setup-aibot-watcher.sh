#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
action="${1:-status}"
action="${action#--}"
[[ $# -eq 0 ]] || shift
exec python3 "$ROOT/scripts/flowctl.py" watcher "$action" "$@"

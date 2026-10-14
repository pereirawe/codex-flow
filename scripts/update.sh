#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
case "${1:-}" in
  --check) git -C "$ROOT" fetch origin; git -C "$ROOT" log --oneline HEAD..origin/main ;;
  --help|-h) echo 'Usage: update.sh [--check]' ;;
  '') git -C "$ROOT" pull --ff-only; python3 "$ROOT/scripts/flowctl.py" install ;;
  *) echo 'Usage: update.sh [--check]' >&2; exit 2 ;;
esac

#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
workspace="${1:?Usage: codex-run.sh <workspace> <workflow> [arguments...]}"
workflow="${2:?Workflow required}"; shift 2
case "$workflow" in
  ocf:*) workflow="${workflow#ocf:}" ;;
esac
prompt="$(python3 "$ROOT/scripts/flowctl.py" prompt "$workflow" "$@")"
args=(exec --cd "$workspace" --add-dir "$ROOT" --color never)
[[ -z "${AIBOT_MODEL:-}" ]] || args+=(--model "$AIBOT_MODEL")
if [[ "${CODEX_RUN_DRY_RUN:-0}" == 1 ]]; then
  printf 'codex'; printf ' %q' "${args[@]}" "$prompt"; printf '\n'; exit 0
fi
exec "${CODEX_BIN:-codex}" "${args[@]}" "$prompt"

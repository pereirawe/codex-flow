#!/usr/bin/env bash
# lib-os.sh — portable helpers for Linux, macOS, and WSL.
# Source after config.sh (optional). Safe to source multiple times.

# flow_realpath <path> — print absolute path (GNU/BSD/Python fallback)
flow_realpath() {
  local p="${1:-}"
  [[ -n "$p" ]] || return 2
  if command -v realpath >/dev/null 2>&1; then
    realpath "$p"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$p"
  else
    # last resort
    (cd "$(dirname "$p")" && echo "$(pwd -P)/$(basename "$p")")
  fi
}

# flow_epoch <timestamp> — UTC unix seconds from ISO/date-ish string
# Accepts: YYYY-MM-DD, YYYY-MM-DDTHH:MM, YYYY-MM-DDTHH:MM:SS[,Z]
flow_epoch() {
  local s="${1:-}"
  [[ -n "$s" && "$s" != "-" ]] || return 1
  python3 -c '
import sys
from datetime import datetime, timezone
raw = sys.argv[1].strip().replace("Z", "")
for fmt, n in (("%Y-%m-%dT%H:%M:%S", 19), ("%Y-%m-%dT%H:%M", 16), ("%Y-%m-%d", 10)):
    try:
        dt = datetime.strptime(raw[:n], fmt)
        print(int(dt.replace(tzinfo=timezone.utc).timestamp()))
        raise SystemExit(0)
    except ValueError:
        continue
raise SystemExit(1)
' "$s" 2>/dev/null
}

# Exclusive lock around issue-tracker mutations.
# Usage:
#   flow_lock_begin "$PROJECT_ISSUES_DIR/.issues.lock"
#   ... critical section ...
#   flow_lock_end   # also registered on EXIT while held
FLOW_LOCK_MODE=""
FLOW_LOCK_DIR=""
FLOW_LOCK_FILE=""

flow_lock_end() {
  case "${FLOW_LOCK_MODE:-}" in
    flock)
      flock -u 9 2>/dev/null || true
      ;;
    mkdir)
      if [[ -n "${FLOW_LOCK_DIR:-}" ]]; then
        rm -rf "$FLOW_LOCK_DIR" 2>/dev/null || true
      fi
      ;;
  esac
  FLOW_LOCK_MODE=""
  FLOW_LOCK_DIR=""
  FLOW_LOCK_FILE=""
}

flow_lock_begin() {
  local file="${1:?lock file path required}"
  FLOW_LOCK_FILE="$file"
  mkdir -p "$(dirname "$file")" 2>/dev/null || true
  if command -v flock >/dev/null 2>&1; then
    exec 9>"$file"
    flock -x 9
    FLOW_LOCK_MODE=flock
  else
    # mkdir is atomic on POSIX; used when util-linux flock is missing (common on macOS).
    FLOW_LOCK_DIR="${file}.d"
    local n=0
    while ! mkdir "$FLOW_LOCK_DIR" 2>/dev/null; do
      sleep 0.05
      n=$((n + 1))
      if [[ "$n" -ge 200 ]]; then
        echo "flow_lock_begin: timeout waiting for $file" >&2
        return 1
      fi
    done
    printf '%s\n' "$$" >"$FLOW_LOCK_DIR/pid" 2>/dev/null || true
    FLOW_LOCK_MODE=mkdir
  fi
  # shellcheck disable=SC2064
  trap 'flow_lock_end' EXIT
}

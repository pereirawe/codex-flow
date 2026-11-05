#!/usr/bin/env bash
# test_lib_os.sh — portable lock + epoch helpers
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib.sh"
source "$HERE/../lib-os.sh"
t_begin "test_lib_os"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"; flow_lock_end 2>/dev/null || true' EXIT

# realpath
RP=$(flow_realpath "$HERE/../lib-os.sh")
[[ -f "$RP" ]] && t_ok "flow_realpath" || t_fail "flow_realpath"

# epoch
E1=$(flow_epoch "2026-11-05T10:00" || true)
E2=$(flow_epoch "2026-11-05" || true)
[[ -n "$E1" && "$E1" =~ ^[0-9]+$ ]] && t_ok "flow_epoch datetime" || t_fail "flow_epoch datetime ($E1)"
[[ -n "$E2" && "$E2" =~ ^[0-9]+$ ]] && t_ok "flow_epoch date" || t_fail "flow_epoch date ($E2)"
flow_epoch "-" >/dev/null 2>&1 && t_fail "flow_epoch rejects -" || t_ok "flow_epoch rejects -"

# lock
flow_lock_begin "$TMP/test.lock"
[[ -n "$FLOW_LOCK_MODE" ]] && t_ok "lock acquired ($FLOW_LOCK_MODE)" || t_fail "lock acquired"
flow_lock_end
[[ -z "$FLOW_LOCK_MODE" ]] && t_ok "lock released" || t_fail "lock released"

t_finish

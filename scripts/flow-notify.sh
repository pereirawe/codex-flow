#!/usr/bin/env bash
# One notification for Codex and Cursor flows. Tries Telegram, then OpenWA.
# Credentials: .codex/telegram.env / .codex/openwa.env (project or ~/.codex/flow/.codex/).
# Exits non-zero when no channel delivers the message.
set -u

here="$(cd "$(dirname "$0")" && pwd)"
if "$here/telegram-notify.sh" "$@"; then
  exit 0
fi
if "$here/openwa-notify.sh" "$@"; then
  exit 0
fi
echo "flow-notify: Telegram and OpenWA both failed; delivery flows should stop" >&2
exit 1

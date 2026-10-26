#!/usr/bin/env bash
# One notification for Codex and Cursor flows. Channel: Telegram.
# Credentials: ./.codex/telegram.env, then ~/.codex/flow/.codex/telegram.env.
set -u

here="$(cd "$(dirname "$0")" && pwd)"
if "$here/telegram-notify.sh" "$@"; then
  exit 0
fi
echo "flow-notify: Telegram did not accept the message; the flow continues" >&2
exit 0

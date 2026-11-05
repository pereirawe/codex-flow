#!/usr/bin/env bash
# issues-migrate.sh — Split known_issues.md + resolved_issues.md into hybrid layout.
# Idempotent if already hybrid (refuses unless --force).
# Usage: issues-migrate.sh [--force] [--keep-monolith]
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib-issues.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib-os.sh"

FORCE=0
KEEP=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --keep-monolith) KEEP=1; shift ;;
    -h|--help)
      echo "Usage: issues-migrate.sh [--force] [--keep-monolith]" >&2
      exit 0 ;;
    *) echo "Unknown: $1" >&2; exit 2 ;;
  esac
done

ISSUES_DIR="$PROJECT_ISSUES_DIR/issues"
if [[ -f "$ISSUES_DIR/index.md" && "$FORCE" -ne 1 ]]; then
  echo "Already hybrid ($ISSUES_DIR/index.md). Pass --force to rebuild from monolith." >&2
  exit 0
fi

[[ -f "$PROJECT_ISSUES_FILE" ]] || { echo "missing $PROJECT_ISSUES_FILE" >&2; exit 2; }

flow_lock_begin "$PROJECT_ISSUES_DIR/.issues.lock"

mkdir -p "$ISSUES_DIR/resolved"

export IM_KNOWN="$PROJECT_ISSUES_FILE" IM_RESOLVED="$RESOLVED_FILE"
export IM_DIR="$ISSUES_DIR"

python3 - <<'PY'
import os, re, pathlib

def split_file(path: pathlib.Path):
    if not path.is_file():
        return []
    text = path.read_text(encoding="utf-8")
    parts = re.split(r"(?m)(?=^### [0-9]+\. )", text)
    out = []
    for p in parts:
        p = p.strip()
        if not p.startswith("### "):
            continue
        m = re.match(r"^###\s+(\d+)\.", p)
        if not m:
            continue
        out.append((int(m.group(1)), p.rstrip() + "\n"))
    return out

known = pathlib.Path(os.environ["IM_KNOWN"])
resolved = pathlib.Path(os.environ["IM_RESOLVED"])
dest = pathlib.Path(os.environ["IM_DIR"])
dest.mkdir(parents=True, exist_ok=True)
(dest / "resolved").mkdir(exist_ok=True)

for iid, body in split_file(known):
    pad = f"{iid:03d}"
    (dest / f"{pad}.md").write_text(body, encoding="utf-8")
    print(f"active {pad}")

for iid, body in split_file(resolved):
    pad = f"{iid:03d}"
    (dest / "resolved" / f"{pad}.md").write_text(body, encoding="utf-8")
    print(f"resolved {pad}")
PY

bash "$(dirname "${BASH_SOURCE[0]}")/issues-reindex.sh"

if [[ "$KEEP" -eq 1 ]]; then
  bash "$(dirname "${BASH_SOURCE[0]}")/issues-reindex.sh" --also-monolith
  echo "Hybrid ready; monolith refreshed as mirror."
else
  # Thin pointer so old tools notice hybrid
  cat >"$PROJECT_ISSUES_FILE" <<EOF
## Known Issues

> **Hybrid tracker.** Canonical bodies live in \`.codex/issues/<id>.md\`.
> Overview: \`.codex/issues/index.md\`. Rebuild with \`issues-reindex.sh\`.
> To regenerate a monolith mirror: \`issues-reindex.sh --also-monolith\`.

EOF
  if [[ -f "$RESOLVED_FILE" ]]; then
    cat >"$RESOLVED_FILE" <<EOF
## Resolved Issues

> Hybrid tracker — resolved bodies in \`.codex/issues/resolved/<id>.md\`.
> Run \`issues-reindex.sh --also-monolith\` if a script still needs this file.

EOF
  fi
  echo "Hybrid ready at $ISSUES_DIR (monolith replaced with pointer)."
fi

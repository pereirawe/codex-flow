#!/usr/bin/env bash
# jira-init.sh — write .codex/jira.json for the current project from the global
# Codetomika portfolio registry + config/jira/defaults.json.
#
# Usage:
#   jira-init.sh                 — resolve key from git repo folder name
#   jira-init.sh --key REV       — force project key
#   jira-init.sh --list          — print registry map
#   jira-init.sh --dry-run       — print JSON without writing
#
set -euo pipefail
source "$(dirname "$0")/config.sh"

REGISTRY="$CONFIG_DIR/config/jira/registry.json"
DEFAULTS="$CONFIG_DIR/config/jira/defaults.json"
EXAMPLE="$CONFIG_DIR/config/jira/defaults.example.json"

usage() {
  cat <<EOF
Usage: jira-init.sh [--key KEY] [--dry-run] [--list] [--force]
  Writes .codex/jira.json (baseUrl, email, projectKey) for this repo.
  Looks up the repo folder in config/jira/registry.json unless --key is set.
EOF
}

KEY=""
DRY=0
LIST=0
FORCE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --key) KEY="${2:-}"; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    --list) LIST=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ ! -f "$REGISTRY" ]]; then
  echo "[jira-init] missing registry: $REGISTRY" >&2
  exit 1
fi

if [[ "$LIST" -eq 1 ]]; then
  python3 - "$REGISTRY" <<'PY'
import json, sys
reg = json.load(open(sys.argv[1]))
site = reg.get("site", {})
print(f"site: {site.get('baseUrl', '')}")
for p in reg.get("projects", []):
    repos = ", ".join(p.get("repos") or []) or "(no repo)"
    print(f"  {p['key']:4}  {p.get('name','')}  ←  {repos}")
PY
  exit 0
fi

if [[ ! -f "$DEFAULTS" ]]; then
  echo "[jira-init] missing $DEFAULTS — copy from $EXAMPLE and set your Atlassian email" >&2
  exit 1
fi

REPO_NAME="$(basename "$FLOW_PROJECT_ROOT")"
OUT_DIR="$FLOW_PROJECT_ROOT/.codex"
OUT_FILE="$OUT_DIR/jira.json"

if [[ -z "$KEY" ]]; then
  KEY="$(python3 - "$REGISTRY" "$REPO_NAME" <<'PY'
import json, sys
reg = json.load(open(sys.argv[1]))
name = sys.argv[2]
for p in reg.get("projects", []):
    for r in p.get("repos") or []:
        if r == name or name.startswith(r + "-") or r.startswith(name):
            # exact match preferred; collected below
            pass
exact = [p["key"] for p in reg.get("projects", []) if name in (p.get("repos") or [])]
if exact:
    print(exact[0]); raise SystemExit
# prefix: codetomika-landing-page → KAN via listed repo
for p in reg.get("projects", []):
    for r in p.get("repos") or []:
        if name == r:
            print(p["key"]); raise SystemExit
print("")
PY
)"
fi

if [[ -z "$KEY" ]]; then
  echo "[jira-init] no registry entry for repo '$REPO_NAME'. Pass --key KEY or update config/jira/registry.json" >&2
  exit 1
fi

# Validate key exists in registry
python3 - "$REGISTRY" "$KEY" <<'PY'
import json, sys
reg = json.load(open(sys.argv[1]))
key = sys.argv[2]
keys = {p["key"] for p in reg.get("projects", [])}
if key not in keys:
    sys.stderr.write("[jira-init] unknown key %r — known: %s\n" % (key, ", ".join(sorted(keys))))
    raise SystemExit(1)
PY

JSON="$(python3 - "$DEFAULTS" "$REGISTRY" "$KEY" <<'PY'
import json, sys
defaults = json.load(open(sys.argv[1]))
reg = json.load(open(sys.argv[2]))
key = sys.argv[3]
site = reg.get("site") or {}
base = defaults.get("baseUrl") or site.get("baseUrl")
email = defaults.get("email")
if not base or not email:
    sys.stderr.write("[jira-init] defaults.json must include baseUrl and email\n")
    raise SystemExit(1)
out = {"baseUrl": base, "email": email, "projectKey": key}
if isinstance(defaults.get("statusMap"), dict):
    out["statusMap"] = defaults["statusMap"]
if isinstance(defaults.get("authMode"), str) and defaults["authMode"]:
    out["authMode"] = defaults["authMode"]
print(json.dumps(out, indent=2) + "\n")
PY
)"

if [[ "$DRY" -eq 1 ]]; then
  printf '%s' "$JSON"
  exit 0
fi

if [[ -f "$OUT_FILE" && "$FORCE" -ne 1 ]]; then
  echo "[jira-init] exists: $OUT_FILE (use --force to overwrite)" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
printf '%s' "$JSON" > "$OUT_FILE"

# Ensure jira.json is gitignored under .codex
GI="$OUT_DIR/.gitignore"
if [[ -f "$GI" ]]; then
  grep -qx 'jira.json' "$GI" 2>/dev/null || printf '\njira.json\n' >> "$GI"
else
  printf 'jira.json\n' > "$GI"
fi

echo "[jira-init] wrote $OUT_FILE (projectKey=$KEY)"
echo "[jira-init] set JIRA_API_TOKEN in the environment to enable sync-jira.sh"

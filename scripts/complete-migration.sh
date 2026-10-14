#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
python3 "$ROOT/scripts/validate.py"
python3 "$ROOT/scripts/tests/test_flowctl.py"
python3 "$ROOT/scripts/tests/test_automation.py"
bash "$ROOT/scripts/tests/run_all.sh" --core
python3 "$ROOT/scripts/flowctl.py" install
python3 - "$ROOT" <<'PY'
import json,pathlib,subprocess,sys
root=pathlib.Path(sys.argv[1]); manifest=root/'.local/projects.json'
if manifest.exists():
 for project in json.loads(manifest.read_text()):
  subprocess.run([sys.executable,str(root/'scripts/flowctl.py'),'project',project],check=True)
PY
if [[ "${1:-}" == --publish ]]; then
  repo="${2:?Usage: complete-migration.sh --publish owner/repo}"
  gh api user --jq .login >/dev/null
  if ! gh repo view "$repo" --json name >/dev/null 2>&1; then
    gh repo create "$repo" --public --description 'Global Codex skills, agents and discovery/develop delivery workflows with project-specific context'
  fi
  git -C "$ROOT" remote set-url origin "https://github.com/$repo.git"
  git -C "$ROOT" push -u origin HEAD:main
  gh repo view "$repo" --json url --jq .url
fi
printf '%s\n' 'Codex Flow installation completed. Open a new chat in the intended project.'

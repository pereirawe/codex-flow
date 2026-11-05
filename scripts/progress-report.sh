#!/usr/bin/env bash
# progress-report.sh — Client progress report from known_issues + resolved.
# Project-local modules/hours come from .codex/progress-modules.json when present.
#
# Usage:
#   progress-report.sh [--date YYYY-MM-DD] [--out FILE] [--project DIR]
#
# Writes docs/progress/<date>-progress-report.md under the project.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

DATE="$(date +%Y-%m-%d)"
OUT=""
PROJECT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --date) DATE="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --project) PROJECT="$2"; shift 2 ;;
    -h|--help)
      echo "Usage: progress-report.sh [--date YYYY-MM-DD] [--out FILE] [--project DIR]" >&2
      exit 0 ;;
    *) echo "Unknown flag: $1" >&2; exit 2 ;;
  esac
done

if [[ -n "$PROJECT" ]]; then
  ROOT="$(cd "$PROJECT" && pwd -P)"
else
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd -P)"
fi

ISSUES="$ROOT/.codex/known_issues.md"
RESOLVED="$ROOT/.codex/resolved_issues.md"
MODULES_JSON="$ROOT/.codex/progress-modules.json"
UNMAPPED="$ROOT/docs/progress/unmapped-tasks.tsv"
PROGRESS_DIR="$ROOT/docs/progress"
HYBRID_INDEX="$ROOT/.codex/issues/index.md"

# Hybrid: refresh monolith mirrors so the Python parser can stay simple.
if [[ -f "$HYBRID_INDEX" ]]; then
  bash "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/issues-reindex.sh" --also-monolith >/dev/null || true
fi

[[ -f "$ISSUES" ]] || { echo "missing $ISSUES" >&2; exit 2; }
[[ -f "$RESOLVED" ]] || touch "$RESOLVED"
mkdir -p "$PROGRESS_DIR/assets"

export PR_ISSUES="$ISSUES" PR_RESOLVED="$RESOLVED" PR_UNMAPPED="$UNMAPPED"
export PR_MODULES="$MODULES_JSON" PR_DATE="$DATE" PR_ROOT="$ROOT" PR_OUT="$OUT"
export PR_PROGRESS="$PROGRESS_DIR"

python3 - <<'PY'
import collections, datetime, json, os, re, pathlib

issues_path = os.environ["PR_ISSUES"]
resolved_path = os.environ["PR_RESOLVED"]
unmapped_path = os.environ["PR_UNMAPPED"]
modules_path = os.environ["PR_MODULES"]
date = os.environ["PR_DATE"]
root = os.environ["PR_ROOT"]
out = os.environ.get("PR_OUT") or ""
progress_dir = os.environ["PR_PROGRESS"]

def parse_issues(path):
    items, cur = [], None
    if not os.path.isfile(path):
        return items
    with open(path, encoding="utf-8") as f:
        for raw in f:
            line = raw.rstrip("\n")
            m = re.match(r"^### (\d+)\. (.*)$", line)
            if m:
                if cur:
                    items.append(cur)
                cur = {
                    "id": int(m.group(1)),
                    "title": m.group(2),
                    "status": "",
                    "type": "",
                    "sev": "",
                    "prio": "",
                    "resolved": "",
                    "durations": "",
                }
                continue
            if cur is None:
                continue
            for field, key in (
                ("Status", "status"),
                ("Type", "type"),
                ("Severity", "sev"),
                ("Priority", "prio"),
                ("Resolved", "resolved"),
                ("Durations", "durations"),
            ):
                mm = re.match(rf"^- {field}:\s*(.*)$", line)
                if mm:
                    cur[key] = mm.group(1).strip()
    if cur:
        items.append(cur)
    return items

active = parse_issues(issues_path)
resolved = parse_issues(resolved_path)
resolved_dedup = {}
for i in resolved:
    resolved_dedup.setdefault(i["id"], i)
resolved_unique = sorted(resolved_dedup.values(), key=lambda i: -i["id"])

status_map = {i["id"]: i["status"] or "backlog" for i in active}
for i in resolved:
    status_map[i["id"]] = "resolved"
title_map = {i["id"]: i["title"] for i in active}
title_map.update({i["id"]: i["title"] for i in resolved})

WEIGHT = {
    "resolved": 1.0,
    "in-publish": 0.95,
    "in-qa": 0.9,
    "in-review": 0.8,
    "in-progress": 0.6,
    "ready": 0.3,
    "open": 0.15,
    "backlog": 0.0,
}

modules = []
total_hours = 0
if os.path.isfile(modules_path):
    data = json.loads(pathlib.Path(modules_path).read_text(encoding="utf-8"))
    total_hours = int(data.get("total_hours") or 0)
    for row in data.get("modules") or []:
        modules.append(
            (row["name"], int(row["hours"]), list(row.get("issues") or []))
        )
    if not total_hours:
        total_hours = sum(h for _, h, _ in modules)

def module_pct(ids):
    if not ids:
        return 0.0
    ws = [WEIGHT.get(status_map.get(i, "backlog"), 0.0) for i in ids]
    return round(sum(ws) / len(ws) * 100, 1)

module_rows = []
for name, hours, ids in modules:
    pct = module_pct(ids)
    module_rows.append({"name": name, "hours": hours, "pct": pct, "issues": ids})

contract_pct = (
    round(sum(r["hours"] * r["pct"] for r in module_rows) / total_hours, 1)
    if total_hours
    else 0.0
)

by_status = collections.Counter(i["status"] or "backlog" for i in active)
done_count = len(resolved_dedup)
total_issues = len({i["id"] for i in active} | set(resolved_dedup))
critical_open = sum(
    1
    for i in active
    if i["sev"] == "critical" and i["status"] in ("backlog", "ready", "open", "in-progress")
)
in_flight = sum(
    by_status[s] for s in ("in-progress", "in-review", "in-qa", "in-publish")
)

# Durations sample from resolved
durs = [i["durations"] for i in resolved_unique if i.get("durations")]

unmapped = []
if os.path.isfile(unmapped_path):
    with open(unmapped_path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                unmapped.append(line)

project_name = pathlib.Path(root).name
lines = []
lines.append(f"# Relatório de Avanço — {project_name}")
lines.append("")
lines.append(f"- **Data:** {date}")
lines.append(f"- **Projeto:** `{root}`")
lines.append("")
lines.append("## Resumo executivo")
lines.append("")
if total_hours:
    lines.append(
        f"- Conclusão ponderada por horas: **{contract_pct}%** ({total_hours}h base)."
    )
else:
    lines.append(
        "- Sem `.codex/progress-modules.json` — % por horas indisponível; métricas por issue abaixo."
    )
lines.append(f"- Issues resolvidas: **{done_count}** / {total_issues}.")
lines.append(f"- Em voo (in-progress…publish): **{in_flight}**.")
lines.append(f"- Críticas abertas: **{critical_open}**.")
if durs:
    lines.append(f"- Amostra de `Durations:` em resolvidas: {len(durs)} issues.")
lines.append("")

if module_rows:
    lines.append("## % por módulo (horas)")
    lines.append("")
    lines.append("| Módulo | Horas | % | Issues |")
    lines.append("|--------|------:|--:|--------|")
    for r in module_rows:
        ids = ", ".join(f"#{i}" for i in r["issues"]) or "—"
        lines.append(f"| {r['name']} | {r['hours']} | {r['pct']} | {ids} |")
    lines.append("")

lines.append("## Status das issues ativas")
lines.append("")
if by_status:
    for st, n in sorted(by_status.items()):
        lines.append(f"- `{st}`: {n}")
else:
    lines.append("- Nenhuma issue ativa.")
lines.append("")

lines.append("## Resolvidas recentes (até 12)")
lines.append("")
for i in resolved_unique[:12]:
    dur = f" — `{i['durations']}`" if i.get("durations") else ""
    lines.append(f"- #{i['id']} {i['title']}{dur}")
lines.append("")

if unmapped:
    lines.append("## Fora da proposta / unmapped")
    lines.append("")
    for u in unmapped:
        lines.append(f"- {u}")
    lines.append("")

lines.append("---")
lines.append(f"_Gerado por `~/.codex/flow/scripts/progress-report.sh` em {date}._")

text = "\n".join(lines) + "\n"
dest = out or os.path.join(progress_dir, f"{date}-progress-report.md")
pathlib.Path(dest).parent.mkdir(parents=True, exist_ok=True)
pathlib.Path(dest).write_text(text, encoding="utf-8")
print(dest)
print(
    f"summary: contract_pct={contract_pct} resolved={done_count}/{total_issues} in_flight={in_flight}"
)
PY

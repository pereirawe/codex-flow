#!/usr/bin/env python3
"""Resolve one Codex Flow catalog entry to an absolute file path.

Usage: flow-resolve.py agent|skill|command <name>
Matches legacy_name, name, and command aliases. Prints one path.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
KINDS = {
    "agent": "catalog/agents.json",
    "skill": "catalog/skills.json",
    "command": "catalog/commands.json",
}


def main() -> int:
    if len(sys.argv) != 3 or sys.argv[1] not in KINDS:
        print(
            "usage: flow-resolve.py agent|skill|command <name>",
            file=sys.stderr,
        )
        return 2
    kind, query = sys.argv[1], sys.argv[2].strip().lstrip("$/")
    items = json.loads((ROOT / KINDS[kind]).read_text(encoding="utf-8"))
    wanted = query.lower()
    for item in items:
        keys = [item.get("legacy_name"), item.get("name"), *(item.get("aliases") or [])]
        if any(isinstance(key, str) and key.lower() == wanted for key in keys):
            path = ROOT / item["path"]
            if not path.is_file():
                print(f"missing file: {path}", file=sys.stderr)
                return 1
            print(path)
            return 0
    print(f"not found: {kind} {query}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())

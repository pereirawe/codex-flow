#!/usr/bin/env python3
"""Resolve project brand + pricing from .codex/brand/ (neutral Flow defaults)."""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

SCHEMA_VERSION = 1


def project_root(start: Path | None = None) -> Path:
    cur = (start or Path.cwd()).resolve()
    for _ in range(12):
        if (cur / ".codex").is_dir() or (cur / ".git").exists():
            return cur
        if cur.parent == cur:
            break
        cur = cur.parent
    return (start or Path.cwd()).resolve()


def brand_dir(root: Path) -> Path:
    return root / ".codex" / "brand"


def load_profile(root: Path) -> dict:
    path = brand_dir(root) / "brand.profile.json"
    if not path.is_file():
        return {}
    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("schema_version", SCHEMA_VERSION) != SCHEMA_VERSION:
        raise ValueError(f"unsupported brand.profile.json schema_version in {path}")
    return data


def parse_pricing_md(text: str) -> dict:
    out: dict[str, str | float] = {}
    for line in text.splitlines():
        m = re.match(r"^\s*hourly_rate\s*:\s*([0-9]+(?:\.[0-9]+)?)\s*$", line, re.I)
        if m:
            out["hourly_rate"] = float(m.group(1))
        m = re.match(r"^\s*currency\s*:\s*(\S+)\s*$", line, re.I)
        if m:
            out["currency"] = m.group(1)
        m = re.match(r"^\s*locale\s*:\s*(\S+)\s*$", line, re.I)
        if m:
            out["locale"] = m.group(1)
    return out


def load_pricing(root: Path) -> dict:
    path = brand_dir(root) / "pricing.md"
    if not path.is_file():
        return {}
    return parse_pricing_md(path.read_text(encoding="utf-8"))


def resolve_logo_file(root: Path, profile: dict) -> Path | None:
    bdir = brand_dir(root)
    rel = profile.get("logo_path") or profile.get("logo") or "logo.png"
    candidate = (bdir / rel).resolve()
    if candidate.is_file() and candidate.is_relative_to(bdir.resolve()):
        return candidate
    for name in ("logo.svg", "logo.png", "logo.jpg", "logo.jpeg", "logo.webp"):
        p = bdir / name
        if p.is_file():
            return p
    return None


def format_rate(amount: float, currency: str, locale: str) -> str:
    cur = (currency or "BRL").upper()
    if cur == "BRL" or locale.lower().startswith("pt"):
        whole = int(round(amount))
        return f"R$ {whole:,}".replace(",", ".")
    return f"{cur} {amount:.2f}"


def placeholders(root: Path | None = None) -> dict[str, str]:
    root = root or project_root()
    profile = load_profile(root)
    pricing = load_pricing(root)
    issuer = profile.get("issuer") or {}
    company = profile.get("company") or issuer.get("name") or "{{company}}"
    locale = str(profile.get("locale") or pricing.get("locale") or "pt-BR")
    currency = str(profile.get("currency") or pricing.get("currency") or "BRL")
    hourly = profile.get("hourly_rate")
    if hourly is None:
        hourly = pricing.get("hourly_rate")
    hourly_f = float(hourly) if hourly is not None else 0.0
    logo = resolve_logo_file(root, profile)
    logo_path = "{{logo_path}}"
    if logo:
        try:
            logo_path = str(logo.relative_to(root))
        except ValueError:
            logo_path = str(logo)
    rate_fmt = format_rate(hourly_f, currency, locale) if hourly_f else "{{hourly_rate}}"
    return {
        "company": company,
        "issuer": issuer.get("name") or company,
        "issuer_name": issuer.get("name") or company,
        "logo_path": logo_path,
        "hourly_rate": str(int(hourly_f)) if hourly_f == int(hourly_f) else str(hourly_f),
        "hourly_rate_formatted": rate_fmt,
        "locale": locale,
        "currency": currency,
    }


def apply_placeholders(text: str, mapping: dict[str, str]) -> str:
    for key, val in mapping.items():
        text = text.replace("{{" + key + "}}", val)
    return text


def main() -> None:
    import argparse

    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--root", type=Path, default=None)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("placeholders", help="Print JSON placeholder map")
    sub.add_parser("logo-path", help="Print resolved logo path or empty")
    p_apply = sub.add_parser("apply", help="Substitute placeholders in stdin → stdout")
    p_apply.add_argument("--root", type=Path, default=None)
    args = ap.parse_args()
    root = project_root(getattr(args, "root", None))

    if args.cmd == "placeholders":
        print(json.dumps(placeholders(root), ensure_ascii=False, indent=2))
    elif args.cmd == "logo-path":
        prof = load_profile(root)
        logo = resolve_logo_file(root, prof) if prof else resolve_logo_file(root, {})
        print(logo or "")
    elif args.cmd == "apply":
        mapping = placeholders(root)
        sys.stdout.write(apply_placeholders(sys.stdin.read(), mapping))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, json.JSONDecodeError, OSError) as e:
        raise SystemExit(str(e))

---
name: cf-security-audit
description: >-
  Defensive security audit router for any local codebase — secure code review,
  OWASP Top 10 / ASVS / WSTG mapping, STRIDE threat modeling, hardening and
  remediation. Use when the user asks for security review, auditoría de
  seguridad, AppSec, OWASP, threat model, hardening, review-security, or to
  audit vulnerabilities in this or other sites/repos. Never plans or runs
  attacks, exploits, payloads, or evasion (VPN/IP bypass).
---

## Codex runtime contract

This workflow was migrated to Codex. Read `~/.codex/flow/docs/runtime.md`
before its first use. Resolve scripts from `~/.codex/flow/scripts/` and run
them with CWD set to the intended project. Read the project's root AGENTS.md,
then `.codex/AGENTS.md` and relevant local context. Project definitions take
precedence over global definitions with the same legacy identifier.

Legacy `Task(role)` means a Codex subagent using the role in the agent catalog;
if that role cannot be selected natively, read its instructions and include
them in the subagent task. Never run OpenCode. Legacy read/glob/grep/skill
names mean the equivalent available Codex file/search/skill tools. Read a
referenced skill by resolving its legacy name in `catalog/skills.json`.
Shell snippets using OpenCode's !`...` notation are examples, not executable
directives: run the corresponding reviewed command with native shell tools.

Inherit Codex permissions and model settings. Old permission YAML is source
metadata, not an enforcement mechanism. Stop on failed gates; never claim
unperformed tests/reviews passed. Only send external notifications/comments
when the user explicitly invokes a workflow that includes them or separately
authorizes them. Mere migration, file reading, or implicit skill selection
does not authorize sending. Do not hide approval rejections from the user.

# Security audit (defensive)

Global Codex Flow skill. Works in any project. Review and hardening only —
never offensive planning or execution.

## Allowed scope

- Review code, configs, auth, sessions, SQLi/XSS/CSRF/IDOR, secrets, deps
- Map findings to OWASP / CWE / ASVS
- STRIDE threat model and remediation recommendations
- Diff review (branch or working tree)
- Defensive verification checklists (expected secure behavior), no payloads

## Forbidden scope

- Attack plans, exploits, offensive PoCs, hostile fuzzing, WAF/IP evasion
- VPN or other tricks to avoid blocks during “attack tests”
- Offensive pentest procedures even when the user says “it is my site”

If asked for an attack: refuse in a few sentences and offer this defensive flow.

## Mode selection

| Request | Action |
|---------|--------|
| Diff / PR / local changes | Agent `development/senior-reviewers/security` or Cursor `security-review` |
| Repo or component audit | Agent `development/security-owasp` + skills below |
| Design / architecture | `threat-modeling` + OWASP consultant mode |
| Defensive test coverage | `owasp-wstg` as a secure-behavior verification checklist only |

## Resolve agent and skills

```bash
python3 ~/.codex/flow/scripts/flow-resolve.py agent development/security-owasp
python3 ~/.codex/flow/scripts/flow-resolve.py agent development/senior-reviewers/security
python3 ~/.codex/flow/scripts/flow-resolve.py skill secure-code-review
python3 ~/.codex/flow/scripts/flow-resolve.py skill owasp-top10
python3 ~/.codex/flow/scripts/flow-resolve.py skill owasp-asvs
python3 ~/.codex/flow/scripts/flow-resolve.py skill owasp-wstg
python3 ~/.codex/flow/scripts/flow-resolve.py skill threat-modeling
```

Read **one** resolved file at a time. Do not open the whole agents tree.

Native Codex agent names: `cf_development_security_owasp`,
`cf_development_senior_reviewers_security`.

## Codex Security plugin (desktop / CLI)

Plugin `codex-security` adds interactive scans (`security-scan`,
`security-diff-scan`, triage). Config: `~/.codex/config.toml` →
`plugins."codex-security@openai-curated"`. Cursor IDE does not load Codex
plugins — use this skill + OWASP agent there. Authenticate via ChatGPT Plugins
if prompted.

## Standard workflow

1. Confirm repo (CWD / absolute path) and scope (diff vs tree vs component).
2. Load project locale if present (`.codex/locale`); reports in the user
   language; keep technical terms (CWE, ASVS) in English.
3. Review with `secure-code-review`; map with `owasp-top10`.
4. Classify: `critical` / `high` / `medium` / `low` / `nit`.
5. Write local report when Flow is in use:
   `.codex/reviews/security-<target>-<YYYY-MM-DD-HHMMSS>.md`
6. Remediation guidance only unless the user asks to implement: prepared
   statements, output encoding, server-side authz, secrets out of repo. Do not
   invent exploits “to demonstrate”.
7. If the project has `known_issues.md` / `known_frontend_issues.md`, propose
   new entries or fixed markers (edit only when the user asks).

## Finding format

```markdown
### [severity] Short title
- Where: `path/file.ext:line`
- CWE / OWASP: …
- Evidence: …
- Impact: …
- Fix: …
```

Critical/high block MR approval in reviewer mode.

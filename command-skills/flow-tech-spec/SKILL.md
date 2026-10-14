---
name: flow-tech-spec
description: ocf:tech-spec
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

---
description: Author a rigorous technical specification for a project. Delegates to the business-ops/spec-writer agent, which bootstraps the workspace, runs structured discovery, invokes C-level experts as needed, and produces docs/specs/<slug>/tech-spec.md with an embedded company logo.
agent: business-ops/spec-writer
---

## $flow-tech-spec

Create or refine a technical specification.

Usage:

```
$flow-tech-spec <slug> [initial scope description]
```

Examples:

```
$flow-tech-spec dia-educacao-2026
$flow-tech-spec loyalty-program "B2C loyalty program with points and tiers"
```

## What happens

1. The `business-ops/spec-writer` agent bootstraps
   `docs/specs/<slug>/` via `scripts/spec-init.sh`, copying the company
   logo from `docs/assets/` or `~/.codex/flow/assets/`.
2. It runs structured discovery across the 12 spec dimensions defined in
   the `tech-spec` skill, asking the user targeted questions in batches.
3. It invokes C-level agents (`cto`, `cmo`, `cfo`, `coo`) in parallel when
   the domain requires senior judgment, and records every consultation in
   the spec's Sign-off section.
4. It drafts the spec following the canonical structure, runs the quality
   checklist, and asks for explicit user sign-off before saving.
5. Output: `docs/specs/<slug>/tech-spec.md`.
6. Optional: if the user provides commercial identities, also write
   `docs/specs/<slug>/proposal-data.json` (client + issuer blocks — see
   the `proposal-writer` skill for the schema) so `$flow-proposal` can reuse
   them later.

## Next step

After approval:

```
$flow-proposal <slug>
```

to generate the commercial proposal from the approved spec.


# Adorable proposal (archived)

This folder holds the **original design-pipeline brainstorm** (shared Claude chat export and first-draft agent markdown). It is **not** the active source of truth.

## Use instead

- **Routing & outputs:** `standards/design-pipeline.md`
- **Active agents:** `agents/design/` (`art-director`, `ui-architect`, `ui-implementer`, `ui-critic`, `ui-auditor`, `ui-refactor-planner`)
- **Orchestration:** `$flow-build-ui`, `$flow-audit-ui` (`command-skills/flow-build-ui/`, `flow-audit-ui/`)
- **Canonical patterns/tokens:** `skills/design/design-tokens`, `reference-library`, `component-patterns`, `visual-hierarchy`

## Legacy notes preserved here

- Early multi-pass rationale (art-director → architect → implementer → critic)
- Issue list from the original review (hardcoded models, skill cross-refs, output file naming)
- Draft agent files that included `model: anthropic/claude-opus-4-5` — **removed in production agents**; models inherit from the Codex session

Long-form chat transcript: see `Readme.md` in this directory.

Reference copies of draft agents: `art-director.md`, `ui-architect.md`, `ui-auditor.md`, `ui-implementer.md`, `ui-refactor-planner.md` (historical only).

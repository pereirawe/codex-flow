---
name: cf-frontend-design
description: Frontend design system and marketing page generation — aesthetic direction,
  design tokens, typography, color systems, CSS architecture, responsive layout, accessibility.
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

# Frontend Design Skill

Build distinctive, conversion-optimized marketing pages.

## Aesthetic Direction

Before writing any code, commit to an explicit direction:
- **Brutalist**: Raw, typography-first, minimal color, intentional ugliness
- **Editorial**: Magazine-quality, generous whitespace, pull quotes, serif fonts
- **Retro-futuristic**: Neon gradients, geometric shapes, glassmorphism
- **Minimalist**: Max whitespace, single accent color, one visual anchor
- **Maximalist**: Rich textures, layered elements, bold patterns

## Design Tokens

### Typography
```css
--font-heading: 'Anybody', 'Instrument Serif', system-ui;
--font-body: 'Public Sans', 'Inter', system-ui;
--font-mono: 'JetBrains Mono', monospace;
--scale: 1.25; /* Major third */
```

### Color System
- Primary (main brand color)
- Secondary (supporting color)
- Accent (highlights, CTAs)
- Surface (backgrounds, cards)
- Text (headings, body, muted)
- Semantic (success, warning, error, info)
- Dark/Light variants for each

### Spacing
- Base unit: 4px or 8px
- Scale: 4, 8, 12, 16, 20, 24, 32, 40, 48, 56, 64, 80, 96

## Design Rules
- Single visual anchor per screen (hero image, illustration, key stat)
- Scannable headlines — reader gets the proposition in 3 seconds
- Motion only where it serves hierarchy (scroll reveals, hover feedback)
- No carousels without narrative purpose
- No generic SaaS card grids as default layout
- Every color choice must meet WCAG AA contrast (4.5:1 normal text)

## Related Skills
- `conversion-optimization` — CRO for pages
- `copywriting` — page copy
- `theme-factory` — design token generation

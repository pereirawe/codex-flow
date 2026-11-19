---
name: cf-marketing-router
description: Route marketing requests to the right cf-marketing-* skill — strategy,
  content, channels, CRO, analytics, and production UI. Read this first when the
  user asks for "marketing help" without naming a channel. Stub skills defer here.
---

## Codex runtime contract

This workflow was migrated to Codex. Read `~/.codex/flow/docs/runtime.md`
before its first use. Resolve scripts from `~/.codex/flow/scripts/` and run
them with CWD set to the intended project. Read the project's root AGENTS.md,
then `.codex/AGENTS.md` and relevant local context. Project definitions take
precedence over global definitions with the same legacy identifier.

Legacy `Task(role)` means a Codex subagent using the role in the role catalog;
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

# Marketing router

Pick **one primary skill** (add secondary only when the brief spans domains). Resolve paths via `catalog/skills.json`.

## Strategy & planning

| User intent | Skill (`legacy_name`) |
|-------------|------------------------|
| GTM, calendar, channel mix, budget | `marketing-plan` |
| Launch / announcement | `launch` |
| ICP, personas, surveys | `customer-research` |
| Competitors, positioning, battlecards | `competitor-intelligence` |
| Market sizing, trends (stub → depth) | `market-research` → also `customer-research`, `competitor-intelligence` |

## Content & copy

| User intent | Skill |
|-------------|--------|
| Editorial plan, clusters, repurposing | `content-strategy` |
| Headlines, ads, emails, voice | `copywriting` |
| Persuasion / behavioral angles | `marketing-psychology` |

## Channels

| User intent | Skill |
|-------------|--------|
| Paid search/social | `ads-campaign` |
| Lifecycle / newsletters | `email-marketing` |
| Outbound sequences | `cold-email` |
| Social organic (stub → depth) | `social-media` → `content-strategy`, `copywriting` |
| Influencers / creators | `influencer-marketing` |
| PR / earned media | `public-relations` |
| LinkedIn carousel PDF | `linkedin-carousel` |
| Video scripts / UGC | `video-production` |

## Pages, CRO & SEO

| User intent | Skill |
|-------------|--------|
| Landing structure + CRO (stub) | `landing-pages` → `conversion-optimization`, `copywriting` |
| Funnel audits, experiments | `conversion-optimization` |
| A/B tests, sample size | `ab-testing` |
| SEO, meta, OG cards | `SEO Optimizer` |
| Marketing page **visual system** (explore) | `frontend-design` |
| Shipped product UI with critic gate | `$flow-build-ui` + `design-tokens` (see `standards/design-pipeline.md`) |
| Token themes for campaigns | `theme-factory` |

## Measurement & ops

| User intent | Skill |
|-------------|--------|
| Dashboards, attribution | `marketing-analytics` |
| Executive marketing report (stub) | `marketing-reports` → `marketing-analytics` |
| Reusable doc/social templates (stub) | `marketing-templates` → `theme-factory`, `copywriting` |
| Slide narrative (stub) | `presentations` → `copywriting`, `marketing-plan` |

## Stubs (pointer-only skills)

These catalog entries are intentionally short — load the router, then the **depth** skills listed above:

- `landing-pages`, `market-research`, `marketing-reports`, `marketing-templates`, `presentations`, `social-media`

## Not marketing (do not route here)

| Domain | Use instead |
|--------|-------------|
| Client delivery hours / progress PDF | `progress-report`, `$flow-progress-report` |
| Internal delivery cost / ledger | `ops-report` |
| Commercial proposal / SOW | `proposal-writer`, `skills/commercial/*` |
| Product analytics / warehouse | `skills/bi/*` (`data-analysis`, `dashboard-design`, …) |
| Company financial model / board pack | `finance-hub` → `skills/finance/*` |

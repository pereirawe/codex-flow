---
name: cf-content-strategy
description: Content operations and editorial strategy — content audits, editorial
  calendars, topic clusters, content repurposing, and full lifecycle management.
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

# Content Strategy Skill

Plan, produce, and optimize content at scale.

## Workflow

### 1. Content Audit
- Inventory all existing content (pages, blogs, assets)
- Score each piece: traffic, engagement, conversion, freshness
- Identify gaps: missing topics, under-served stages, outdated pieces
- Categorize by funnel stage: TOFU / MOFU / BOFU

### 2. Topic Strategy
- **Keyword research**: Search volume, keyword difficulty, SERP intent
- **Topic clusters**: Pillar page + supporting cluster content with internal links
- **Content formats**: Blog post, guide, template, video, infographic, podcast
- **Distribution channels**: Organic search, social, email, syndication

### 3. Editorial Calendar
- Monthly/quarterly calendar with topics, formats, channels, owners
- Content pillars aligned with product themes and business goals
- Seasonal and event-driven content slots
- Repurposing plan: one asset → multiple formats

### 4. Production Pipeline
- Brief → Outline → Draft → Review → Edit → Publish
- Quality gates: factual accuracy, SEO optimization, brand voice, CTA alignment
- SEO meta: title tag (≤60 chars), meta description (≤160 chars), URL slug, alt text

### 5. Repurposing Framework
| Source | Repurpose To |
|--------|-------------|
| Blog post | LinkedIn post, tweet thread, newsletter, video script |
| Webinar | Blog post, clips, quote cards, transcript |
| Report | Infographic, slide deck, social series, PR pitch |
| Podcast | Show notes, clips, transcripts, social quotes |

## Related Skills
- `copywriting` — content production
- `email-marketing` — content distribution
- `seo-optimizer` — organic discovery
- `social` — social distribution

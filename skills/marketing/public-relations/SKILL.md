---
name: cf-public-relations
description: Public relations and earned media — press releases, media outreach, journalist
  targeting, crisis communications, thought leadership positioning.
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

# Public Relations Skill

Build earned media coverage and manage brand reputation.

## PR Workflow

### 1. Story Development
- **News angle**: What makes this newsworthy? (not just promotional)
- **Timely hook**: Industry trend, data release, cultural moment
- **Human element**: Founder story, customer impact, team milestone
- **Visual asset**: Demo video, infographic, photography

### 2. Media Targeting
- Tier 1: Top-tier outlets (TechCrunch, Forbes, WSJ, Bloomberg)
- Tier 2: Industry-specific publications
- Tier 3: Niche blogs, newsletters, podcasts
- Tier 4: Local/regional press
- Build per-journalist profiles: beat, recent articles, pitching style

### 3. Pitch & Press Release

**Pitch (email to journalist)**:
- Subject: 8-12 words, specific and intriguing
- First line: Why this matters to their readers now
- 3 bullet points max: key facts, data points, exclusivity
- CTA: Interview availability, embargo date, assets

**Press Release Structure**:
- Headline: Strong verb + news + result
- Subheadline: Supporting context
- Dateline + lead paragraph (5 Ws)
- Body: Key details, quotes, data
- About company boilerplate
- Media contact information

### 4. Crisis Communications
- **First hour**: Acknowledge the situation internally
- **First 3 hours**: Internal alignment on key messages
- **First 24 hours**: Public statement if warranted
- Ongoing: Monitor coverage, update messaging, direct response

## Thought Leadership
- Byline articles on industry publications
- Podcast appearances (pitch templates per show)
- Conference speaking (CFP templates)
- LinkedIn long-form posts
- Original research/data reports (earned media driver)

## Related Skills
- `launch` — announcement coordination
- `content-strategy` — thought leadership content
- `social` — amplification
- `marketing-plan` — integrated campaigns

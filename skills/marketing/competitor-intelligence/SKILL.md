---
name: cf-competitor-intelligence
description: Competitive intelligence and market positioning — competitor profiling,
  messaging analysis, positioning gap identification, comparison page creation.
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

# Competitor Intelligence Skill

Systematically analyze competitors and identify market opportunities.

## Analysis Framework

### 1. Competitor Identification
- **Direct**: Same problem, same solution category
- **Indirect**: Same problem, different approach
- **Emerging**: New entrants or adjacent players
- **Legacy**: Traditional solutions (spreadsheets, agencies, manual)

### 2. Intelligence Gathering
- Website: messaging, positioning, pricing, feature claims
- Reviews: G2, Capterra, App Store — what customers love/hate
- Content: blog topics, content quality, SEO strategy, thought leadership
- Social: followers, engagement rate, content themes
- Ads: Facebook Ad Library, Google Ads transparency
- Product: feature set, UX, integrations, limitations
- Funding: investors, amount, stage, growth trajectory

### 3. Positioning Matrix

| Dimension | Us | Competitor A | Competitor B |
|-----------|----|-------------|-------------|
| Target ICP | | | |
| Primary value prop | | | |
| Key differentiator | | | |
| Pricing model | | | |
| Strengths | | | |
| Weaknesses | | | |

### 4. Gap Analysis
- **Underserved needs**: What customers want that competitors don't deliver
- **Over-served segments**: Where competitors over-deliver for their target
- **Messaging gaps**: Claims competitors can't make that you can
- **Channel gaps**: Where competitors have weak distribution

### 5. Comparison Pages
"Us vs Competitor" pages rank for high-intent search terms.
Structure:
- Feature comparison table (your strengths highlighted)
- Use case scenarios where you win
- Pricing comparison
- Customer quotes/testimonials
- Direct CTA to try your solution

## Related Skills
- `customer-research` — ICP alignment
- `copywriting` — differentiation messaging
- `seo-optimizer` — comparison page SEO
- `marketing-plan` — strategy application

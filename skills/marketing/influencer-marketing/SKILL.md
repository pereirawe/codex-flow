---
name: cf-influencer-marketing
description: Influencer and creator marketing — partner identification, outreach,
  campaign structure, ambassador programs, measurement and ROI.
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

# Influencer Marketing Skill

Build and manage creator partnerships at scale.

## Partner Identification

### Fit Criteria
- **Audience overlap**: Does their audience match your ICP?
- **Engagement rate**: >3% for micro, >1% for macro
- **Content quality**: Production value, authenticity, brand alignment
- **Past partnerships**: Relevant brand collaborations
- **Values alignment**: No conflicting or controversial associations

### Discovery Channels
- Social platform search (hashtags, keywords, location)
- Influencer marketplaces (GRIN, Aspire, Upfluence)
- Competitor partnerships (who do they work with?)
- Organic mentions and affiliates already using your product
- CRM: existing customers who are creators

## Outreach Template

```
Subject: [Mutual connection/touchpoint] + [compliment]

Hi [Name],

I've been following your [specific content series/topic] — particularly
[specific post/video]. Your take on [topic] really resonated because
[reason].

We're building [product] for [ICP], and I think your audience would
genuinely find value in [specific angle].

Would you be open to a quick chat about a potential partnership?
No commitment — I'd love to hear your perspective first.

Best,
[Name]
```

## Campaign Structure

| Tier | Followers | Compensation | Deliverables | Usage |
|------|-----------|-------------|--------------|-------|
| Nano | 1K-10K | Free product + $50-200 | 1-2 posts | UGC, reviews |
| Micro | 10K-100K | $200-2,000 | 2-3 posts + story | Reviews, tutorials |
| Mid | 100K-500K | $2,000-10,000 | 3-5 posts + video | Campaign lead |
| Macro | 500K+ | $10K+ | Campaign package | Brand awareness |

## Measurement
- Engagement rate, reach, impressions
- Click-through rate and traffic
- Conversion rate and attributed revenue
- Cost per engagement and cost per acquisition
- Brand lift surveys for larger campaigns

## Related Skills
- `marketing-plan` — campaign integration
- `social` — content amplification
- `launch` — campaign timing

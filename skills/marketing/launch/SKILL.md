---
name: cf-launch
description: Product launch and GTM campaign planning — launch strategy, announcement
  planning, multi-channel distribution, launch calendar, PR coordination.
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

# Launch Skill

Plan and execute coordinated product and feature launches.

## Launch Phases

### Pre-Launch (4-6 weeks before)
- **Positioning**: Define the narrative, key messages, target audience
- **Assets**: Landing page, blog post, social assets, email templates, PR materials
- **Teaser campaign**: Social hints, email countdowns, community build-up
- **Beta/early access**: Recruit testers, collect testimonials
- **Internal readiness**: Sales enablement, support training, documentation

### Launch Day
- Coordinated publishing across all channels (time-zone optimized)
- Email blast to segmented list
- Social announcements (organic + paid if budgeted)
- PR outreach and press release
- Community posts (Reddit, Slack, Discord, LinkedIn groups)

### Post-Launch (2-4 weeks after)
- Performance analysis: traffic, signups, revenue by channel
- Follow-up emails: case studies, testimonials, secondary features
- Paid amplification: retargeting, lookalike audiences
- Iterate based on feedback and data

## Launch Checklist
- [ ] Core narrative and messaging document
- [ ] Landing page with clear value prop and CTA
- [ ] Blog post or announcement article
- [ ] Email sequence (pre-announcement, launch, follow-up)
- [ ] Social media content calendar (all platforms)
- [ ] Press release and media outreach list
- [ ] Sales enablement materials (deck, one-pager, FAQ)
- [ ] Support documentation and training
- [ ] Analytics tracking and conversion goals
- [ ] Post-launch review scheduled

## Multi-Channel Distribution Plan

| Channel | Pre-Launch | Launch Day | Post-Launch |
|---------|-----------|------------|-------------|
| Email | Teaser, waitlist | Launch announcement | Follow-up, case study |
| Blog | - | Announcement post | Deep dive, tutorial |
| Social | Hints, countdown | Coordinated posts | Engagement, UGC |
| PR | Embargoed brief | Press release | Follow-up stories |
| Paid | Retargeting pixel | Launch campaign | Retargeting |
| Community | Teasers | Announcement | AMA, feedback |

## Related Skills
- `marketing-plan` — campaign integration
- `copywriting` — launch copy
- `email-marketing` — launch email sequence
- `public-relations` — media outreach
- `marketing-analytics` — performance tracking

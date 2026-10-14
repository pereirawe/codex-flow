---
name: cf-video-production
description: Video marketing strategy and production — scriptwriting, storyboarding,
  AI video generation, UGC ads, product demos, social video formats.
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

# Video Production Skill

Plan and produce video content for marketing campaigns.

## Video Types & Formats

### Product Demos (2-3 min)
- Problem setup → Solution reveal → Key features → Results → CTA
- Screen recording + voiceover or talking head
- Focus on one workflow or use case

### UGC-Style Ads (15-60 sec)
- Hook (first 3 seconds): grab attention with pain point or bold claim
- Problem statement: "I tried X and it was terrible, so I found Y"
- Solution demo: quick feature walkthrough
- Results: before/after, metrics, testimonial
- CTA: limited-time offer or free trial

### Explainer Videos (60-90 sec)
- Big question → Problem → Solution → How it works → CTA
- Animated or live-action
- Script-first, then storyboard

### Social Shorts (15-60 sec)
- Platform-native: vertical (9:16) for Reels/Shorts/TikTok
- Fast pacing: cut every 2-3 seconds
- Hook on screen in first 3 seconds
- Captions burned in for silent viewing
- Platform-specific trends and audio

## Script Structure

```
Opening hook (3-5 sec): Bold claim or relatable problem
Setup (10-15 sec): Context — who is this for?
Body (20-40 sec): Key message with proof points
Close (10-15 sec): CTA with specific next step
```

## Production Workflow
1. **Brief**: Goal, audience, platform, key message
2. **Script**: Dialog, visual direction, timing
3. **Storyboard**: Key frames per scene
4. **Production**: Record or generate assets
5. **Post-production**: Edit, captions, music, color grade
6. **Optimization**: Platform-specific crops, thumbnails, descriptions
7. **Distribution**: Schedule, captions, hashtags, SEO

## Related Skills
- `copywriting` — video scripts
- `social` — platform distribution
- `launch` — campaign integration

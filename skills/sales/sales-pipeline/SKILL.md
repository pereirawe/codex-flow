---
name: cf-sales-pipeline
description: Sales pipeline management and forecasting — CRM ops, pipeline stages,
  velocity analysis, MEDDIC qualification, forecast modeling, deal inspection, win/loss
  analysis.
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

# Sales Pipeline Skill

Build and manage a predictable sales pipeline with enterprise qualification.

## Qualification Frameworks

### BANT
| Element | Questions |
|---------|-----------|
| Budget | Do they have allocated budget? What range? What procurement process? |
| Authority | Are we talking to the decision-maker? Who else needs to approve? |
| Need | What specific problem are they solving? How urgent? |
| Timeline | When do they need to decide? When do they need it live? |

### MEDDIC
| Element | Definition |
|---------|------------|
| Metrics | Quantified business impact — what specific number needs to move? |
| Economic Buyer | Person with budget authority — have we met them? |
| Decision Criteria | What factors will they use to choose? Can we shape them? |
| Decision Process | Step-by-step: who evaluates, who approves, how long? |
| Identify Pain | Specific, measurable pain — not general discomfort |
| Champion | Internal advocate who sells for us — do they have access/credibility? |

### SPICED
| Element | Questions |
|---------|-----------|
| Situation | What's happening now? What's the context? |
| Pain | What's the specific, quantified problem? |
| Impact | What happens if they don't solve it? |
| Critical Event | What deadline or trigger forces action? |
| Decision | Who decides? What's the process? When? |

### SPIN (Situation, Problem, Implication, Need-Payoff)
- **Situation**: Facts about current environment
- **Problem**: Difficulties, dissatisfactions
- **Implication**: Consequences of the problem
- **Need-Payoff**: Value of solving it

### Challenger Sale
- **Teach**: Unique insights that challenge their thinking
- **Tailor**: Message adapted to their specific context
- **Take Control**: Push back on objections, drive the process

### Gap Selling
- **Current State**: Where they are (pain, cost of doing nothing)
- **Future State**: Where they want to be (vision, value)
- **The Gap**: What's required to close it (your solution, change management)

## Pipeline Stages & Exit Criteria

| Stage | Exit Criteria | MEDDIC Check |
|-------|---------------|--------------|
| Lead | Fit confirmed, contact verified | Nothing yet |
| SQL | Pain identified, budget exists, timeline known | Pain, Budget |
| Demo | Decision criteria known, champion identified | Criteria, Champion |
| Evaluation | Technical validation done, buyer engaged | Metrics, Economic Buyer |
| Negotiation | All stakeholders engaged, decision process mapped | Decision Process |
| Closed Won | Contract signed, implemented | All complete |

## Forecasting Methodology
- **Commit Forecast**: Deals with MEDDIC fully verified, stage ≥ Negotiation
- **Best Case**: Commit + deals with champion, criteria shaping confirmed
- **Pipeline**: All open deals weighted by stage probability
- **Velocity**: Cycle time by segment, source, AE — where deals stall most
- **Win Rate by Source**: Inbound vs outbound vs partner vs referral — adjust forecast weights

## Deal Inspection
1. Pain specific and measurable?
2. Champion identified and verified?
3. Economic buyer engaged?
4. Decision criteria known?
5. Competition understood?
6. Timeline real and urgent?
7. Next step committed?

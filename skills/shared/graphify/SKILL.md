---
compatibility: Codex with local shell tools
name: cf-graphify
description: Generate Mermaid.js diagrams from code structure, architecture, agent
  pipeline, and tracked issues
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

## What I do

- Analyze codebase structure and generate Mermaid diagrams
- Visualize agent pipeline and workflow from `workflow.md`
- Generate architecture diagrams from `architecture.md`
- Create dependency graphs from project structure
- Visualize issue relationships from `known_issues.md`
- Write output to `.mmd` files for rendering

## Diagram types supported

- **Flowchart** (`graph TD`) — agent pipeline, workflows, state machines
- **Class diagram** (`classDiagram`) — architecture layers, module relationships
- **Dependency graph** (`graph LR`) — module/package dependencies
- **Timeline** (`timeline`) — issue lifecycle, sprint progress
- **Gitgraph** (`gitGraph`) — branch strategy visualization
- **Mindmap** (`mindmap`) — project structure, directory tree

## Rules

- Always output valid Mermaid syntax
- Prefer concise, readable diagrams over exhaustive ones
- Write diagrams to `<name>.mmd` files in the project root or `.codex/` directory
- When referencing files, use paths relative to the diagram file location
- Prefer `flowchart` over `graph` in Mermaid v10+ (they're equivalent but `flowchart` is recommended)
- Include a `%%` comment header with the source and generation date
- Never modify source code — only read it

## Usage examples

```
# Generate architecture diagram
skill: graphify "Generate architecture diagram from architecture.md"

# Generate agent pipeline flowchart
skill: graphify "Generate agent pipeline flowchart from workflow.md"

# Generate issue dependency graph
skill: graphify "Graph issue dependencies from known_issues.md"
```

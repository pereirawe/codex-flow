---
name: flow-cv-interview-prep
description: Generate a structured interview preparation kit from candidate hub
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

## $flow-cv-interview-prep <candidate-directory> <job>


Generates a structured interview preparation kit for a specific job
application, from the candidate's `hub.json` (built with `$flow-cv-hub`) and
the job description. The kit covers the four preparation blocks — **likely
interview questions** (behavioral + technical), **suggested STAR answers**
mapped to real hub experience, **questions to ask the interviewer** and
**technical topics to review** — plus a **preparation gaps** section flagging
anything the hub cannot evidence. Nothing is fabricated: STAR answers always
reference real hub entries, and questions are derived from the job's
requirements and seniority.

### Prerequisite

The candidate needs a valid hub at `~/career/<candidate-name>/hub.json`.
If it does not exist, run `$flow-cv-hub` first.

### Usage

```
$flow-cv-interview-prep ~/career/maria-silva "job description text"
```

The job can be provided as:
- **Pasted text** of the description (recommended — most reliable);
- **Local file** (txt/html/pdf) with the description;
- **Official LinkedIn export** (local Download My Data files).

URLs are NOT accepted — linkedin.com is never scraped. If the user pastes a
URL, ask them to paste the job description text instead.

### Flow

1. **Validate hub** — `python3 $SCRIPTS_DIR/cv/validate.py hub.json`; if the
   hub is missing/invalid, tell the user to run `$flow-cv-hub` first.
2. **Invoke the agent** `career/cv-interview-prep` via `task:` with the
   candidate directory and the job.
3. **Analyze the job** — required/desirable requirements, keywords, seniority,
   languages; these define the role the kit prepares for.
4. **Generate the kit** —
   - Likely interview questions (behavioral + technical, role-appropriate);
   - Suggested STAR answers mapped to REAL hub entries (experience
     achievements, project impact, certifications, summary) — each citing its
     hub entry; no hub evidence → preparation gap;
   - Questions to ask the interviewer;
   - Technical topics to review (have from the hub vs gap topics);
   - Preparation gaps (questions/requirements the hub cannot evidence).
5. **Write** `~/career/<candidate-name>/interview-preparation.md` following
   the `standards/cv-analysis.md` structure (exactly one H1 title, NO
   metadata header, start directly with content), in the user's communication
   language per `standards/cv-analysis.md` §1.

### Output

```
~/career/<candidate-name>/interview-preparation.md
```

Sections: Target role | Likely interview questions (Behavioral; Technical) |
Suggested STAR answers | Questions to ask the interviewer | Technical topics
to review (Have from the hub; Gap topics) | Preparation gaps.

### Rules

- NEVER invent experience, skills, achievements, projects or content — STAR
  answers MUST reference real hub entries; no hub evidence → preparation gap.
- NO `[INFERIDO]` in `interview-preparation.md` (nor case-insensitive
  variants, nor the word "inferido") — actionable preparation file, same rule
  as final resume PDFs per `standards/cv-analysis.md` §5.
- Questions MUST be role-appropriate (derived from the job's requirements and
  seniority).
- Report language = the user's communication language (never the job language
  by default).
- No sensitive data (CPF, full address, bank).

### Report to the user

- Output path (`~/career/<candidate>/interview-preparation.md`).
- The target role used (job title, company, seniority).
- Summary of the kit: question count (behavioral/technical), STAR answers
  count, questions-to-ask count, technical topics count (have/gap),
  preparation gaps count — no `[INFERIDO]` markers in the actionable
  preparation file.


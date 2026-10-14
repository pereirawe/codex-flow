---
name: cf-data-analysis
description: Exploratory and statistical data analysis — descriptive statistics, hypothesis
  testing, cohort analysis, funnel analysis, regression, segmentation.
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

# Data Analysis Skill

Extract actionable insights from data with statistical rigor.

## Analysis Framework

### 1. Define Question
- What business decision will this analysis inform?
- What specific metrics answer the question?
- What data sources are available?

### 2. Collect & Prepare
- Data source identification and extraction
- Missing value treatment
- Outlier detection (IQR method, z-score)
- Feature engineering for analysis

### 3. Exploratory Analysis
- Summary statistics (mean, median, distribution, variance)
- Trend and seasonality decomposition
- Correlation matrix of key variables
- Segment drill-downs (by cohort, channel, region)

### 4. Statistical Methods

| Method | Use Case |
|--------|----------|
| T-test / Mann-Whitney | Compare two groups (A/B, test vs control) |
| ANOVA | Compare three+ groups |
| Chi-square | Test categorical associations |
| Linear regression | Continuous outcome prediction |
| Logistic regression | Binary outcome prediction |
| Time series (ARIMA, Prophet) | Forecasting with seasonality |
| Clustering (K-means, RFM) | Customer segmentation |

### 5. Insight Generation
- **What**: Observation (the data says X)
- **So what**: Implication (this means Y for the business)
- **Now what**: Recommendation (therefore we should do Z)

## Cohort Analysis
- Time-based: users grouped by signup month
- Behavior-based: grouped by first action
- Metric: retention, revenue, engagement over time
- Format: heatmap (cohorts × time periods)

## Related Skills
- `analytics-engineering` — data access
- `dashboard-design` — visualization
- `marketing-analytics` — marketing analysis
- `revenue-analytics` — revenue analysis

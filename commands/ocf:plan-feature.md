## $flow-plan-feature

---
description: Alias of $discovery for feature planning — registers a planned feature as a linted, tracked issue
---

`$flow-plan-feature` is now an alias of `$discovery`. Feature planning goes
through the same discovery loop (`feat-full`): PO captures business rules +
`Tests:`, TL sets branch + reviewers, and the issue is written canonically and
linted before it reaches delivery.

Use:

```
$flow-plan-feature "Add CSV export to reports"
```

which is equivalent to:

```
$discovery "Add CSV export to reports"
```

The working directory (`$PWD`) determines the target project. All paths are
relative to the project root. After planning, deliver with
`$develop-full <id>`.

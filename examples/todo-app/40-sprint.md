# Sprint 1 — Household Todo: core loop

**Theme:** a single shared list you can add to and see live (M1 + the start of M2).

| # | Story | Parent epic | Security? | Status |
|---|-------|-------------|-----------|--------|
| 1 | S1 — Data model + create todo | E1 | no | todo |
| 2 | S2 — List & render todos | E1 | no | todo |
| 3 | S3 — Live sync via subscription | E2 | no | todo |

Status: `todo` → `in-progress` → `done`. Updated as the execution loop runs.

## Execution notes
- **Builder:** MiniMax M3 (default single-model; these are grunt/moderate lanes).
- **Quality gate:** ponytail runs inside each build iteration before the PR opens.
- **Review gate:** Codex + Grok + Claude. None flagged security-sensitive this sprint, so the lighter gate applies; S3 graduates to the full gate once household scoping (E4) is added.
- **Hand-off:** one git branch per story; PR per story; never the working tree.

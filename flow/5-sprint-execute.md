# Stage 5 — Sprint & autonomous execution

**Goal:** batch stories into a sprint and hand each story to the autonomous build loop until its acceptance criteria pass.

**Powered by:** [gstack](https://github.com/garrytan/gstack) sprint / goal-loop conductors + [ponytail](https://github.com/DietrichGebert/ponytail) as the build-leg quality gate. See [`docs/models-and-quality-gate.md`](../docs/models-and-quality-gate.md).

## Run

1. Group ready stories into a **coherent sprint** (related stories so context carries). Use [`templates/sprint.md`](../templates/sprint.md).
2. For each story, dispatch the gstack execution conductor on your build agent. The per-story loop is:
   ```
   build  ──▶  ponytail gate (inside build)  ──▶  review  ──▶  QA  ──▶  commit/PR
     ▲                                                              │
     └──────────────── iterate until acceptance criteria pass ──────┘
   ```
3. **Builder ≠ reviewer.** Cheap open-weight model builds; frontier models (Codex / Grok / Claude) review adversarially. Security-flagged stories (from Stage 4) **must** go through the full review gate — non-negotiable.
4. Hand off between agents via **git branches**, never the working tree.

## Output

- One PR per story, each passing its acceptance criteria, ponytail gate, and the review gate.
- Update the sprint file with status per story (todo / in-progress / done) as the loop runs.

## Guardrails

- One PR per story — if the loop produces a sprawling diff, the story was too big (go back to Stage 4).
- Don't let a story "pass" without its objective acceptance check actually green.
- Watch for build-agent teardowns on long runs; salvage from the worktree and resume.
- Keep the quality gate *inside* the build — catching over-engineering after the PR is open is too late.

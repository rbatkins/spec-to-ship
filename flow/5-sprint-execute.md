# Stage 5 — Sprint & autonomous execution

**Goal:** batch stories into a sprint and hand each story to the autonomous build loop until its acceptance criteria pass.

**Powered by:** [gstack](https://github.com/garrytan/gstack) sprint / goal-loop conductors + [ponytail](https://github.com/DietrichGebert/ponytail) as the build-leg quality gate. See [`docs/models-and-quality-gate.md`](../docs/models-and-quality-gate.md).

## Run

1. Group ready stories into a **coherent sprint** (related stories so context carries). Use [`templates/sprint.md`](../templates/sprint.md).
2. For each story, dispatch the gstack execution conductor on your build agent. The per-story loop is:
   ```
   build ─▶ ponytail gate (inside build) ─▶ validate ─▶ frontier gate ─▶ author: design-conformance + merge
     ▲                                          │
     └──────── iterate until acceptance criteria pass ────┘
   ```
   To run the multi-model roles as separate reliable dispatches instead of one stall-prone mission process, use the conductor in [`docs/build-pipeline.md`](../docs/build-pipeline.md) ([`templates/pipeline.sh`](../templates/pipeline.sh)).
3. **Builder ≠ reviewer, at every layer.** Cheap open-weight model builds; frontier models (Codex / Grok / Claude) review adversarially; the planner doesn't review its own plan. Security-flagged or architectural stories (from Stage 4) **must** go through the full gate — non-negotiable.
4. **Design-conformance is the author's, and it's not optional.** After the review gate is green, the author diffs the build against the story and confirms it built *what was specified* — a clean code review doesn't prove that. Only then merge. See [`docs/build-pipeline.md`](../docs/build-pipeline.md#the-gate-the-author-keeps).
5. Hand off between agents via **git branches**, never the working tree.

## Output

- One PR per story, each passing its acceptance criteria, ponytail gate, and the review gate.
- Update the sprint file with status per story (todo / in-progress / done) as the loop runs.
- **Emit one [outcome event](../templates/outcome-event.json) per story** when it finishes — pass *or* fail. This record is the **quality-per-dollar numerator**: it captures whether the story was *accepted* (acceptance criteria + review gate both passed), how many *iterations* it took, and which *builder model* ran it. It's a **vendor-neutral interface** — any cost/usage tracker can join it to token/$ data by model + time. Append it to an append-only outcome stream (`outcomes.jsonl`) wherever your tracker reads from; [Token-Efficiency](https://github.com/rbatkins/Token-Efficiency) is the reference consumer, but the loop doesn't depend on any particular one.

> The numerator counts **accepted outcomes, never lines of code** — see [`docs/measuring-quality.md`](../docs/measuring-quality.md). Record `net_loc_delta` only as an inverse diagnostic (less code for the same outcome = better); it must never drive the metric.

## Guardrails

- One PR per story — if the loop produces a sprawling diff, the story was too big (go back to Stage 4).
- Don't let a story "pass" without its objective acceptance check actually green.
- Watch for build-agent teardowns on long runs; salvage from the worktree and resume.
- Keep the quality gate *inside* the build — catching over-engineering after the PR is open is too late.

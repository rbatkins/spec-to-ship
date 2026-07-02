# The build pipeline — a deterministic mission-mode mimic

> This is the **how stage 6 actually runs** doc. The [loop](the-loop.md) says "hand each story to the execution conductor"; this says what that conductor does, who owns each step, and why one gate is deliberately **not** automated. Reference conductor: [`templates/pipeline.sh`](../templates/pipeline.sh).

## The problem it solves

Native **mission** orchestration — one long-lived process with a lead that plans, workers that build, and a validator that checks — is the *right shape*. It maps cleanly onto the [orchestrator / worker / validator split](models-and-quality-gate.md). But a single multi-role process is a **single point of stall**: the worker-spawn handoff can hang with no error and no progress (see [gotchas](gotchas.md#execution-agent-factory-droid)), and when it does you lose the whole run.

The fix is not a better mission process — it's to **keep the flow and drop the single process.** Rebuild `plan → build → validate → gate` as a chain of **reliable single-model dispatches** driven by a plain script. Each dispatch either returns or fails fast; nothing hangs waiting on an internal handoff. You get the same multi-role flow, the same different-model-per-role separation, at the same (or lower) cost — minus the stall.

## The flow

```
 [--arch]  PLANNER    plan   the PRD        → plan.md      (reasoner; never reviews its own plan)
           BUILDER    build  the code       → lane branch  (cheap open-weight)
   loop ┌─ VALIDATOR  validate the diff     → PASS / FIX-FIRST   (cheap pre-gate filter)
        │    FIX-FIRST → BUILDER fixes the findings → re-validate   (all open-weight; no frontier spend)
        └─  PASS      → break
           GATE       codex + grok          → PASS / FIX-FIRST   (frontier, adversarial, independent)
           ─────────────────────────────────────────────────────────────
           STOP. Surface verdicts to the AUTHOR for the two judgment gates below.
```

The script **ends at the frontier gate.** The last two reviews are judgment, not mechanics, so a human (the author) does them — see [The gate the author keeps](#the-gate-the-author-keeps).

## The ownership map

Every rung has one owner, and the owner of an *artifact* is never the sole judge of its *soundness*.

| Step | Owner | Produces / decides |
|---|---|---|
| First principles, roadmap, epics, **PRD/story, architecture** | **Author** (you, +human/frontier planning personas) | the spec and the design the build must realize |
| Decomposition of a hard PRD into a build plan (`--arch`) | **Planner model** | file-by-file plan, migration list, build order — *only when the lane is architectural; most lanes skip it* |
| Orchestration (the passing + the fix loop) | **The script** | mechanical only — no judgment, no review |
| Build + fixes | **Builder model** (open-weight) | the code |
| Pre-gate validation | **Validator model** | cheap catch of real defects before frontier spend |
| Frontier gate | **codex + grok** | adversarial code review, independent of the builder |
| **Design-conformance** + security + **merge** | **Author** | did the build match the design; is it safe; does it land |

Default is the **simple spine** — no `--arch` plan pass. Reach for the planner only when a lane is genuinely architectural (new subsystem, migration-heavy, cross-cutting); for the common one-PR story, `build → validate → gate` is the whole thing. Adding rungs a lane doesn't need is its own kind of over-engineering — the [ponytail](https://github.com/DietrichGebert/ponytail) stance applies to the *process*, not just the code.

## Author ≠ reviewer — at every layer

[models-and-quality-gate.md](models-and-quality-gate.md) states the load-bearing rule for code: **the model that builds is never the model that reviews.** The pipeline extends it up the whole ladder:

- The **planner** decomposes a PRD but does **not** later review its own plan's soundness.
- The **builder** writes code but does **not** review it — the validator and the frontier gate do, and they are different models.
- The **author** writes the PRD/design but does **not** get to declare it *sound* alone — that's what the planning personas and the design panel are for (upstream).

But there is one thing only the author can do, and it is the exception that proves the rule.

## The gate the author keeps

Every reviewer in the flow — validator, codex, grok — judges the code **on its own merits**: is it correct, safe, tested, un-over-engineered? None of them judges it **against the spec**, because the spec is the author's intent and they weren't in the room for it. So there is a gate no model in the chain can run:

> **Design-conformance:** the author diffs the build against the PRD/design they wrote and asks — *did it implement what I specified, and where did it drift?*

This is not the author re-reviewing their own design's soundness (that happened upstream, with other voices). It is the author checking the **realization against the intent** — the one review where being the author is a qualification, not a conflict. In practice it catches the most expensive class of miss: a build that passes every code review because the code is *fine*, but quietly didn't wire up the thing the lane existed to deliver. A clean frontier gate is necessary but not sufficient; conformance is the "…and it's the thing we actually asked for" gate. It runs on **every** lane, security or not.

`--sec` lanes add one more author-owned pass — an implementation-security review — before merge. Then the author merges. The script does none of these three: they are judgment, and judgment is not delegated to the conductor.

## Using it

```bash
# simple lane (most stories): build → validate → frontier gate
templates/pipeline.sh <lane-branch> path/to/prd.md

# architectural lane: add the planner decomposition pass first
templates/pipeline.sh <lane-branch> path/to/prd.md --arch

# security-sensitive lane: mark the author security pass REQUIRED in the summary
templates/pipeline.sh <lane-branch> path/to/prd.md --sec
```

Set `BUILDER_MODEL` / `VALIDATOR_MODEL` / `PLANNER_MODEL` (and `BUILD_CMD`, `BASE`, `PONYTAIL`) for your agent — the script ships with placeholder names because, like the rest of this repo, **every piece is swappable**. The durable part is the *shape*: different model per role, a cheap validate loop before frontier spend, and two gates the author never hands to a machine.

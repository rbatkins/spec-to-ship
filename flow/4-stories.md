# Stage 4 — Stories

**Goal:** decompose each epic into **stories sized to exactly one pull request**, each with explicit acceptance criteria.

**This sizing is what makes autonomous execution reliable** — a one-PR story is one the build loop can objectively verify it finished.

## Run

1. Take one epic at a time.
2. Cut it into stories where **each story = one coherent PR**: a few files, one reviewable change, independently shippable.
3. For each story write **acceptance criteria** as checkable statements (Given/When/Then or a bullet checklist). These become the build loop's verification gate.

## Output (hand to Stage 5)

Use [`templates/story.md`](../templates/story.md). Each story:
- Title + parent epic
- The change in one sentence
- **Acceptance criteria** (objective, checkable)
- **Invariants** — the non-negotiables to bake in *now* (see below)
- Test notes (what proves it works)
- Out of scope
- **Class** — simple, or *architectural* (drives whether Stage 6 runs the planner pass and which review tier)

### Invariants — the part that saves the rewrite

Acceptance criteria say *what this PR does*. **Invariants** say *what must stay true no matter how it's built* — the properties a cheap builder will silently violate unless you name them: idempotency keys, tenancy/scope isolation, fail-closed defaults, "raw secrets never logged," attribution stamped on every row. Write them into the story so the builder designs *to* them and every reviewer checks *against* them. Naming an invariant now is how you avoid re-architecting under the second user/tenant/feature later. A story that touches data ownership, auth, or money without an invariants section isn't ready.

### Architectural stories get a design doc first

Most stories are self-contained — the acceptance criteria *are* the spec. But a story that introduces a subsystem, a migration-heavy change, or a cross-cutting contract needs a **design** before a build: write it down, and get its *soundness* reviewed by other voices (planning personas / a design panel) **before** it becomes a build spec. Link that design doc from the story and mark the story **architectural**. The author owns the design; the author does **not** get to rubber-stamp its soundness alone — that's what the upstream review is for. (See [author ≠ reviewer at every layer](../docs/build-pipeline.md#author--reviewer--at-every-layer).)

## Guardrails

- If a story can't be expressed as one PR, split it.
- Acceptance criteria must be **objective** — "looks good" is not a criterion; "POST /todos returns 201 and the row exists" is.
- A story with no test/verification path is not ready for autonomous execution — add one or send it back.
- **Name the invariants** for any story touching data ownership, tenancy, auth, or money — don't assume the builder will infer them.
- Security-sensitive or architectural stories: flag them here so Stage 6 routes them through the planner pass and/or the full adversarial review gate.
- The story is what **design-conformance** is checked against at Stage 6 — if the story is vague, "did the build match the spec?" has no answer. Write it to be checkable.

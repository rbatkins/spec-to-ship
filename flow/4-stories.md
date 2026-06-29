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
- Test notes (what proves it works)
- Out of scope

## Guardrails

- If a story can't be expressed as one PR, split it.
- Acceptance criteria must be **objective** — "looks good" is not a criterion; "POST /todos returns 201 and the row exists" is.
- A story with no test/verification path is not ready for autonomous execution — add one or send it back.
- Security-sensitive stories: flag them here so Stage 6 routes them through the full adversarial review gate.

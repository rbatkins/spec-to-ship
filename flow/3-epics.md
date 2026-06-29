# Stage 3 — Epics

**Goal:** break each roadmap milestone into **epics** — shippable chunks of user-visible value. "Big enough to matter, small enough to finish."

## Run

1. Take one roadmap milestone at a time.
2. Split it into epics, each of which delivers something a user would notice on its own.
3. For each epic, state the **acceptance outcome** (how you'd know it's done from the outside) and call out **non-goals** (what it explicitly does not include).

## Output (hand to Stage 4)

Use [`templates/epic.md`](../templates/epic.md). Each epic:
- Title + the parent milestone
- Acceptance outcome (user-visible)
- Non-goals
- Rough size and dependencies

## Guardrails

- An epic is still too big to be one PR — that's fine, it becomes several stories in Stage 4.
- If an "epic" has no user-visible outcome, it's probably a task hiding as an epic — fold it into the epic it serves.
- Keep epics independent where possible so they can be sequenced and parallelized.

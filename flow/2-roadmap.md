# Stage 2 — Roadmap

**Goal:** turn the design doc into a **sequenced set of outcomes/milestones** — what value, in what order, and why that order.

**This is spec-to-ship's spine.** gstack is thin here; everything below hangs off this.

## Run

1. Read `design-doc.md` from Stage 1.
2. Express the product as **outcomes** (user-visible value), not features. Each outcome answers "what can the user now do / what is now true?"
3. **Sequence** them. Order by: riskiest-assumption-first, then dependency, then value-per-effort. State *why* this order.
4. Mark the **first shippable slice** (the smallest sequence prefix that delivers real value).

## Output (hand to Stage 3)

Use [`templates/roadmap.md`](../templates/roadmap.md). Each milestone:
- Outcome statement
- Why it's here / why now (the sequencing rationale)
- Rough size (S / M / L)
- Dependencies

## Guardrails

- Outcomes, not tasks. If it reads like a to-do, it's too low.
- 3–7 milestones for a first roadmap. More than that means you're decomposing too early.
- Every milestone must trace back to something in the design doc.

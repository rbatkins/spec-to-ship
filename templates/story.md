# Story — <title>

- **Parent epic:** <epic title>
- **The change (one sentence):** <one coherent PR's worth of work>
- **Class:** simple / architectural  <!-- architectural → design doc + Stage 6 planner pass; link it below -->
- **Security-sensitive?** yes / no  <!-- if yes, Stage 6 routes through the FULL review gate + author security pass -->
- **Design doc:** <link, if architectural — the reviewed-for-soundness design this build must realize>

## Acceptance criteria (objective, checkable)
> These criteria **are** the quality definition for this story — what counts as "done" is these passing + the review gate, **not** how much code it took. See [docs/measuring-quality.md](../docs/measuring-quality.md).

- [ ] <Given/When/Then or a concrete checkable statement>
- [ ] <e.g. "POST /todos with a title returns 201 and persists a row">

## Invariants (must stay true however it's built)
> Not "what this PR does" — what the builder must **not** violate. Name them or a cheap builder will. Skip only if the story truly touches no data ownership / auth / money.

- [ ] <e.g. "idempotency key = (tenant_id, external_id) — never global id alone">
- [ ] <e.g. "a second tenant's rows are unreadable through this tenant's scope by construction, not by app-code filtering">
- [ ] <e.g. "raw secrets/bodies never logged, hashed, or put in a cursor; fail closed on missing scope">

## Can this be satisfied with less or no code? (ponytail check)
<The best version of this story may remove code or avoid it entirely. Note the leanest path that still meets the criteria — parsimony is a quality win, not a shortfall.>

## Test notes
<what proves it works — unit test, endpoint call, UI assertion. Include a test per invariant above.>

## Out of scope / non-goals
<explicitly not part of this story — deferrals stated so the builder doesn't gold-plate>

## Design-conformance (author, before merge)
<After the review gate passes, the AUTHOR diffs the build against THIS story: did it implement what's specified, and where did it drift? A clean code review means the code is fine — not that it built the thing asked for. This gate is the author's, and it runs on every lane. See [docs/build-pipeline.md](../docs/build-pipeline.md#the-gate-the-author-keeps).>

## Outcome (filled by the execution loop — feeds quality-per-dollar)
<On completion, emit an [outcome event](outcome-event.json): accepted? acceptance criteria passed/total, review verdict, iterations, builder model. `net_loc_delta` is recorded as an inverse diagnostic only — never the metric.>

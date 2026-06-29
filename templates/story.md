# Story — <title>

- **Parent epic:** <epic title>
- **The change (one sentence):** <one coherent PR's worth of work>
- **Security-sensitive?** yes / no  <!-- if yes, Stage 6 routes through the FULL review gate -->

## Acceptance criteria (objective, checkable)
> These criteria **are** the quality definition for this story — what counts as "done" is these passing + the review gate, **not** how much code it took. See [docs/measuring-quality.md](../docs/measuring-quality.md).

- [ ] <Given/When/Then or a concrete checkable statement>
- [ ] <e.g. "POST /todos with a title returns 201 and persists a row">

## Can this be satisfied with less or no code? (ponytail check)
<The best version of this story may remove code or avoid it entirely. Note the leanest path that still meets the criteria — parsimony is a quality win, not a shortfall.>

## Test notes
<what proves it works — unit test, endpoint call, UI assertion>

## Out of scope
<explicitly not part of this story>

## Outcome (filled by the execution loop — feeds quality-per-dollar)
<On completion, emit an [outcome event](outcome-event.json): accepted? acceptance criteria passed/total, review verdict, iterations, builder model. `net_loc_delta` is recorded as an inverse diagnostic only — never the metric.>

# Roadmap — Household Todo

## First shippable slice
> **M1 + M2** — a single shared list you can add to and check off, live.

---

### M1 — A list exists and persists
- **Outcome:** a user can create todo items and they survive a refresh.
- **Why here / why now:** nothing else has value without durable items; lowest risk, foundational.
- **Size:** S
- **Depends on:** —

### M2 — The list is shared and live
- **Outcome:** two devices see the same list update in near-real-time.
- **Why here / why now:** this is the wedge (the riskiest assumption from office-hours). Build it early to de-risk the whole idea.
- **Size:** M
- **Depends on:** M1

### M3 — Completing and clearing
- **Outcome:** users can check items off and clear completed ones.
- **Why here / why now:** completes the core loop; low risk once M1/M2 hold.
- **Size:** S
- **Depends on:** M1

### M4 — One household, one list
- **Outcome:** a shared household code scopes the list so only members see it.
- **Why here / why now:** needed before real use, but deferred until the core proves out.
- **Size:** M
- **Depends on:** M2

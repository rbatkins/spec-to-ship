# Stories — Household Todo (epics E1–E2)

Each story = one PR. Acceptance criteria are objective so the build loop can verify them.

---

## S1 — Data model + create todo  *(epic E1)*
- **Change:** add a `todos` table and a `POST /todos` endpoint.
- **Security-sensitive?** no
- **Acceptance criteria:**
  - [ ] `POST /todos` with `{ "title": "milk" }` returns `201` and a body with an `id`.
  - [ ] A row exists in `todos` with that title after the call.
  - [ ] Empty/missing title returns `400`.
- **Test notes:** endpoint test for 201 + 400; DB assertion on the row.
- **Out of scope:** listing, UI.

## S2 — List & render todos  *(epic E1)*
- **Change:** `GET /todos` + a minimal list UI that renders them.
- **Security-sensitive?** no
- **Acceptance criteria:**
  - [ ] `GET /todos` returns all items as JSON.
  - [ ] The UI shows items from `GET /todos` and a newly added item appears after refresh.
- **Test notes:** endpoint test; one UI assertion that a seeded item renders.
- **Out of scope:** real-time updates (S3).

## S3 — Live sync via subscription  *(epic E2)*
- **Change:** push todo changes to connected clients (websocket / realtime channel).
- **Security-sensitive?** no  *(becomes yes once E4 scoping lands — flag then)*
- **Acceptance criteria:**
  - [ ] An item created on client A appears on client B within ~1s with no manual refresh.
  - [ ] No duplicate render when the creating client also receives the broadcast.
- **Test notes:** integration test with two clients; assert propagation + dedupe.
- **Out of scope:** household scoping, offline queueing.

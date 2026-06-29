# Epics — Household Todo

## E1 — Todo CRUD + persistence  *(milestone M1)*
- **Acceptance outcome:** a user can add a todo and see it after a page refresh.
- **Non-goals:** sharing, real-time, auth, completion UI.
- **Size:** S · **Depends on:** —

## E2 — Real-time shared list  *(milestone M2)*
- **Acceptance outcome:** an item added on device A appears on device B within ~1s without a manual refresh.
- **Non-goals:** per-household scoping (that's E4), conflict resolution beyond last-write-wins.
- **Size:** M · **Depends on:** E1

## E3 — Complete & clear  *(milestone M3)*
- **Acceptance outcome:** a user can toggle an item complete and clear all completed items; changes propagate live.
- **Non-goals:** undo, archived history.
- **Size:** S · **Depends on:** E1

## E4 — Household scoping  *(milestone M4)*
- **Acceptance outcome:** entering a household code shows only that household's list; a different code shows a different list.
- **Non-goals:** user accounts, roles, invitations by email.
- **Size:** M · **Depends on:** E2

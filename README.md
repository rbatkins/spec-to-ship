# spec-to-ship

**Take a one-line product idea all the way to executing sprints — autonomously.**
First principles → roadmap → epics → stories → sprints → it builds, reviews, and ships each story, with a code-quality gate wired into the build.

This is a thin **orchestration layer on top of two excellent open-source projects** — it does not replace or fork either:

- **[gstack](https://github.com/garrytan/gstack)** by **Garry Tan** — the planning personas (`/office-hours`, CEO/Eng/Design/QA reviews) and the sprint/goal-loop execution conductors.
- **[ponytail](https://github.com/DietrichGebert/ponytail)** by **Dietrich Gebert** — the code-quality / anti-over-engineering gate, embedded into the build leg.

> See **[CREDITS.md](CREDITS.md)**. spec-to-ship is the glue, the decomposition ladder, and the runbooks — gstack and ponytail do the heavy lifting.

---

## Why this exists

gstack is excellent at the two *ends* of the lifecycle — **thinking** (office-hours + review personas) and **executing** (sprint/goal-loop conductors run a spec to a PR). The thin spot is the **middle**: taking a raw idea and *decomposing* it into a structured backlog the execution end can run autonomously.

spec-to-ship fills that middle with an explicit **decomposition ladder**, then hands each rung to gstack's own execution loop — with **ponytail** as a quality gate inside the build so nothing ships without a "should we even have written this code?" pass.

**The promise: idea in → sprints executing out.**

---

## The loop

```
        ┌─────────────────────────────────────────────────────────────┐
  idea ─┤ 1. First principles   →  gstack /office-hours                │
        │    (is this worth building? what is it actually?)            │
        │ 2. Roadmap            →  outcomes & milestones, sequenced    │
        │ 3. Epics              →  shippable chunks of value           │
        │ 4. Stories            →  single-PR-sized, acceptance criteria│
        │ 5. Sprints            →  stories batched into executable work │
        │ 6. Autonomous execute →  gstack sprint/goal-loop drives       │
        │      (per story)         build → review → QA → ship           │
        │            └──▶ ponytail gate inside the build leg ──────────│──▶ ships
        └─────────────────────────────────────────────────────────────┘
```

Full stage-by-stage walkthrough: **[docs/the-loop.md](docs/the-loop.md)**.

---

## Quickstart

```bash
git clone https://github.com/rbatkins/spec-to-ship && cd spec-to-ship
./bootstrap.sh          # checks prereqs, installs/points to gstack + ponytail, verifies
#   (Windows: ./bootstrap.ps1)

# then, in your AI coding tool, point it at the flow and give it an idea:
"Run the spec-to-ship loop on: <your one-line product idea>"
```

The agent walks the ladder in `flow/`, producing a roadmap → epics → stories → sprints, then hands each story to gstack's execution conductor. Watch a real idea walk the whole ladder in **[examples/todo-app/](examples/todo-app/)**.

---

## What's in here

| Path | What it is |
|---|---|
| `flow/` | The five-stage runbook the agent follows (first-principles → sprint execution) |
| `docs/the-loop.md` | The loop explained, stage by stage |
| `docs/models-and-quality-gate.md` | The build/review split, the model matrix, and where ponytail hooks in |
| `docs/measuring-quality.md` | What "quality" means here — accepted outcomes, **not** lines of code — and the quality-per-dollar metric |
| `docs/gotchas.md` | Hard-won lessons that save you hours (Windows, embeddings, Droid CLI, …) |
| `examples/todo-app/` | One idea taken idea → roadmap → epics → stories → sprint, so you see the shape |
| `templates/` | Blank roadmap / epic / story / sprint templates to copy |
| `bootstrap.sh` / `.ps1` | Prereq check + install/verify helper |

---

## Prerequisites

- **[gstack](https://github.com/garrytan/gstack)** installed (the planning + execution skills). Follow its README.
- **[ponytail](https://github.com/DietrichGebert/ponytail)** installed (the quality gate).
- An AI coding tool that runs gstack skills (e.g. Claude Code).
- For the autonomous execution leg as described in the docs: an autonomous build agent. This repo documents the setup with **[Factory Droid](https://factory.ai)** (open-weight builders served via **[Fireworks AI](https://fireworks.ai)**, gated by frontier reviewers) — but the loop is agent-agnostic.

`bootstrap.sh` checks for these and points you at each project's install instructions; it does not silently install third-party tools on your behalf.

---

## Contributing

Contributions are welcome via fork + pull request — and every change is reviewed and approved by the maintainer before it merges. `main` is protected; there is no direct push. See **[CONTRIBUTING.md](CONTRIBUTING.md)**.

## Credits & license

Built on and grateful to **[gstack](https://github.com/garrytan/gstack)** (Garry Tan) and **[ponytail](https://github.com/DietrichGebert/ponytail)** (Dietrich Gebert). Full attributions in **[CREDITS.md](CREDITS.md)**.

spec-to-ship is released under the **[MIT License](LICENSE)**. gstack and ponytail are governed by their own licenses — see their repositories.

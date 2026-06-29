# The loop, stage by stage

spec-to-ship turns a one-line idea into executing sprints. Stages 1, 6 and the quality gate are powered by **[gstack](https://github.com/garrytan/gstack)** and **[ponytail](https://github.com/DietrichGebert/ponytail)**; stages 2–5 (the decomposition ladder) are what this repo adds.

```
  idea
   │
   ▼
1. First principles  ──  gstack /office-hours        (is this worth building?)
   │
   ▼
2. Roadmap           ──  sequenced outcomes/milestones
   │
   ▼
3. Epics             ──  shippable chunks of value
   │
   ▼
4. Stories           ──  one-PR-sized, with acceptance criteria
   │
   ▼
5. Sprints           ──  stories batched into an executable unit
   │
   ▼
6. Execute (per story) ─ gstack sprint/goal-loop: build → review → QA → ship
        └── ponytail quality gate runs INSIDE the build leg
```

## 1. First principles — `gstack /office-hours`
Before any code, run the idea through office-hours. Output is a **design doc and a clear go/no-go**, not a backlog. This kills bad ideas cheaply and gives every later stage a north star. *(gstack)*

## 2. Roadmap
Turn the design doc into **sequenced outcomes/milestones** — what value, in what order, and why that order. This is the layer gstack is thinnest on, and it's the spine everything below hangs from. Template: [`templates/roadmap.md`](../templates/roadmap.md).

## 3. Epics
Each roadmap milestone becomes one or more **epics** — a shippable chunk of user-visible value. "Big enough to matter, small enough to finish." Template: [`templates/epic.md`](../templates/epic.md).

## 4. Stories
Each epic decomposes into **stories sized to one pull request**, each with explicit acceptance criteria. This sizing is what makes autonomous execution reliable — a story that maps to one PR is one the build loop can objectively verify it finished. Template: [`templates/story.md`](../templates/story.md).

## 5. Sprints
Stories batch into a **sprint** — the unit you hand to the execution loop. Keep sprints coherent (related stories) so context carries. Template: [`templates/sprint.md`](../templates/sprint.md).

## 6. Autonomous execution — `gstack` sprint / goal-loop
Each story is handed to gstack's sprint/goal-loop conductor running on an autonomous build agent. The conductor drives **build → review → QA → commit/PR**, iterating against an objective verification gate until the story's acceptance criteria pass. *(gstack, + your build agent.)*

The **quality gate** lives *inside* the build leg: see [`models-and-quality-gate.md`](models-and-quality-gate.md).

---

See [`examples/todo-app/`](../examples/todo-app/) for a full worked pass through all six stages.

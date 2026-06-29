# Credits

spec-to-ship is a thin orchestration layer. The hard, valuable work is done by other people's projects. This file exists to make that explicit and to point you to them.

## Core dependencies

### gstack — Garry Tan
- **Repo:** https://github.com/garrytan/gstack
- **What it provides:** the planning personas (`/office-hours` and the CEO / Eng Manager / Designer / QA review modes) and the sprint / goal-loop **execution conductors** that take a spec to a pull request.
- **Role in spec-to-ship:** the entire "thinking" front-end and the autonomous "executing" back-end. spec-to-ship only adds the **decomposition ladder** in the middle (roadmap → epics → stories → sprints) and the runbooks that chain it all together.
- License: see the gstack repository (MIT at time of writing).

### ponytail — Dietrich Gebert
- **Repo:** https://github.com/DietrichGebert/ponytail
- **What it provides:** a code-quality / anti-over-engineering gate — *"the best code is the code you never wrote,"* making the agent think like the laziest senior dev in the room.
- **Role in spec-to-ship:** the **quality gate embedded inside the build leg**, run on every build iteration *before* a PR is opened, so needless code is caught while it's still cheap to back out.
- License: see the ponytail repository.

## Tools referenced in the documented setup

These are not required by the loop (which is agent-agnostic) but are the configuration spec-to-ship's docs describe:

- **Factory Droid** — https://factory.ai — the autonomous build agent for the execution leg, chosen for its native mission structure (orchestrator / worker / validator).
- **Fireworks AI** — https://fireworks.ai — the US-based inference provider Factory standardized on for serving open-weight models, so inference runs on US infrastructure rather than the model vendors' own APIs.

Open-weight models referenced (each governed by its own license, by its respective lab): MiniMax M3, GLM-5.2, Kimi K2.7 Code, DeepSeek V4 Pro. Frontier reviewers referenced: Codex (OpenAI), Grok (xAI), Claude (Anthropic).

---

If you build on spec-to-ship, please keep the gstack and ponytail attributions intact — they earned them.

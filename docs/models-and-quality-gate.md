# Models & the quality gate (the execution leg)

> The loop is **agent-agnostic**. This doc describes the specific, battle-tested configuration spec-to-ship has been run with. Swap any piece.

## The quality gate — ponytail, inside the build

**[ponytail](https://github.com/DietrichGebert/ponytail)** is wired into the build leg, **not bolted on after.** Its stance is *"the best code is the code you never wrote"* — it makes the agent think like the laziest senior dev in the room. Running it **inside** each build iteration (before the PR is opened) means over-engineering and needless code get caught while the agent can still cheaply back them out, instead of surviving into review. The gate is part of "done," not a later step.

## The load-bearing principle: builder ≠ reviewer

**The model that *builds* is never the model that *reviews*.**

- **Builders** — open-weight, cheap, high-volume. The builder burns the most tokens, so that's where cheap models pay off.
- **Reviewers** — frontier, adversarial, and *separate*. Any builder can introduce a regression, so the reviewer must be a different and stronger model than the one that wrote the code. Non-negotiable on security-sensitive lanes.

## The matrix

| Side | Role | Model | What it does | When it runs |
|---|---|---|---|---|
| **Build** | Default builder (single-model) | MiniMax M3 | Writes the code | Most lanes — cheapest, teardown-resilient |
| **Build** | Orchestrator | GLM-5.2 | Plans & decomposes | Hardest lanes (mission stack) |
| **Build** | Worker | Kimi K2.7 Code | Writes the code | Hardest lanes (mission stack) |
| **Build** | Validator | DeepSeek V4 Pro | Catches subtle bugs before review | Hardest lanes (mission stack) |
| **Review** | Adversarial gate | Codex + Grok + Claude | Independently reviews / tries to refute the build | Every lane — non-negotiable on security-sensitive lanes |

*Model IDs and costs move fast — treat the names as a mid-2026 snapshot and the **roles** as the durable part.*

## Why Factory for this leg — and why it's safe

1. **Mission structure.** [Factory Droid](https://factory.ai)'s mission mode is native multi-role orchestration — a lead that plans, workers that build, validators that check — which maps onto the orchestrator/worker/validator split above out of the box.
2. **Data security via US-based inference.** Factory serves its open-weight models through **[Fireworks AI](https://fireworks.ai)**, a US-based inference provider it standardized on for open models. The model *weights* may be open and globally sourced, but **inference runs on US infrastructure, not the Chinese vendors' own APIs** (whose hosted endpoints can route data through servers subject to China's data laws). That serving path — not the models' origin — is what makes an open-weight build side acceptable for sensitive code.

> Note: the US-via-Fireworks property holds for Factory's standard open-model serving. If you BYOK Droid to a different endpoint (or self-host elsewhere), re-verify the data path.

## Cost intuition

Builders run the most tokens, so cheap open-weight models there are the single biggest lever. Frontier models earn their keep as the **gate**, not the **producer** — a frontier model is wasted writing boilerplate and invaluable refuting it.

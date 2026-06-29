# Measuring quality — and why it's not lines of code

The whole point of spec-to-ship is to maximize **quality work per dollar**. That only works if "quality" is measured at the right altitude. Get the numerator wrong and you optimize for the wrong thing.

## The trap: lines of code

If "quality" means **lines of code**, you reward bloat — and you reward the exact behavior [ponytail](https://github.com/DietrichGebert/ponytail) exists to prevent (*"the best code is the code you never wrote"*). A LOC-based metric puts your measurement and your quality gate in direct conflict: ponytail removes code, your metric punishes it for doing so. That's a Goodhart failure — the measure becomes a target and stops measuring anything real.

**So LOC is never the numerator.** A story solved by *deleting* code, or with 10 lines instead of 200, is worth exactly as much as any other accepted story — because the unit is the **outcome**, not the diff.

## The unit: an accepted outcome

spec-to-ship already denominates work in outcomes, not code:

- **roadmap** → outcomes (what the user can now do)
- **epics** → shippable chunks of value
- **stories** → one-PR units **with objective acceptance criteria**

So the quality unit is simply:

> **a story whose acceptance criteria passed and survived the review gate.**

That's value-denominated by construction. No code-volume proxy required — the gate verdict on the story *is* the quality measure.

### The Goodhart guard

You can't farm the numerator with trivial stories, because **every story must trace up to a roadmap outcome**. The ladder forces each story to be a real slice of real user value. Fragmenting work into tiny fake stories doesn't increase delivered outcomes, so it doesn't move the metric.

## Net-LOC is a diagnostic, read *inversely*

We still record `net_loc_delta` per story — but as a **diagnostic only**, never the numerator, and we read it **inversely**: *less* code for the same accepted outcome is *better*. A negative delta (code removed) that still passes acceptance is a quality win, not a shortfall. This is the number that lets you *see* ponytail working.

## The formula

$$\text{quality per dollar} = \frac{\text{accepted stories (outcome units)}}{\text{effective \$ (cap consumption + overage)}}$$

- **Numerator** — accepted, gate-passing stories. Produced by the loop; captured by the [outcome event](../templates/outcome-event.json).
- **Denominator** — your real spend. Under a flat-subscription stack this is *cap consumption + any overage*, not per-token price — but token efficiency still matters, because a cache-cheap, low-rework model fits **more** accepted outcomes under the same fixed budget before caps bind.

Both axes feed one number. A better builder choice (cheaper cache *and* fewer iterations to pass) raises the numerator **and** lowers the denominator at once — which is why "token efficiency" and "quality" are not separate optimizations here. They're two hands on the same dial.

## How it's computed (numerator here, denominator anywhere)

```
spec-to-ship                          any cost/usage tracker
─────────────                         ──────────────────────
ladder → stories (acceptance crit.)   token / $ rows (real usage)
gate (ponytail + reviewers)
   │                                          │
   └──▶ outcome-event.json ──join by model/time──▶ quality per dollar
        NUMERATOR: accepted outcomes          DENOMINATOR: effective $
```

spec-to-ship owns the **numerator** (this repo) and emits it as a **vendor-neutral** [outcome event](../templates/outcome-event.json). The **denominator** lives in whatever tracks your token/$ usage — it joins the outcome stream by model + time and computes the ratio **per builder model**, so a routing decision shows up directly as a quality-per-dollar delta. [Token-Efficiency](https://github.com/rbatkins/Token-Efficiency) is the reference consumer, but any tracker works and the loop depends on none of them. See [`flow/5-sprint-execute.md`](../flow/5-sprint-execute.md) for where the event is emitted.

## Effective Tokens (ET)

The same idea, stated token-side: **ET = tokens that produced accepted work**, as opposed to tokens burned on rework or rejected output. Quality-per-dollar is ET made financial. A high rework ratio (many iterations per accepted story) means a low ET fraction — your dollars are buying motion, not outcomes. That's the number to drive down.

# Contributing to spec-to-ship

Thanks for your interest! Contributions are welcome — and every change is reviewed and approved by the maintainer before it lands.

## How to propose a change

You **cannot push directly** to this repository, and that's by design. The flow is:

1. **Open an issue first** for anything non-trivial — describe the change and why. For small fixes (typos, broken links, doc clarifications), you can skip straight to a PR.
2. **Fork** the repo to your own account.
3. Create a branch in your fork and make your change.
4. **Open a Pull Request** against `main` here.
5. The maintainer reviews it. Nothing merges without that review — `main` is protected and requires a PR.

## What makes a good PR

- **One focused change per PR.** Easier to review, easier to accept.
- **Keep the credits intact.** This project stands on [gstack](https://github.com/garrytan/gstack) (Garry Tan) and [ponytail](https://github.com/DietrichGebert/ponytail) (Dietrich Gebert) — see [CREDITS.md](CREDITS.md). Don't strip or bury those attributions.
- **Match the existing tone** in the docs and `flow/` runbooks: short, concrete, no fluff.
- **Don't add hard dependencies** without discussion. The point of this repo is to be a thin layer; new required tools change that.
- **No secrets, ever.** No API keys, tokens, connection strings, or private paths in commits.

## Scope

This repo is the **decomposition ladder + runbooks + docs** that sit on top of gstack and ponytail. Improvements to the ladder, the templates, the worked example, the docs, and the bootstrap helpers are all in scope. Changes that belong in gstack or ponytail themselves should be proposed in those projects.

## Licensing

By contributing, you agree your contributions are licensed under the repository's [MIT License](LICENSE).

## A note on conduct

Be kind and assume good faith. This is a small, friendly project.

# Hard-won gotchas

The kind of thing that costs hours if you don't know it. All generic to the stack — no product specifics.

## gstack setup
- **Windows installs skills as file *copies*, not symlinks.** On macOS/Linux a `git pull` of gstack auto-refreshes installed skills via symlinks. On Windows they're copied, so **re-run gstack's `./setup` after every `git pull`** or you'll silently run stale skills.
- **`./setup` can deadlock unzipping Chromium** (Playwright headless-shell extraction hang). There's no skip-browser flag. Bypass: download the archive and `tar`-extract it manually rather than letting the installer unzip it. Only the browser-driven skills need Chromium at runtime; the rest of setup is unaffected.
- **`jq` is a silent prerequisite.** Several gstack artifact-sync steps and the preamble need `jq` on PATH; if it's missing they fail in confusing ways. Install it first.

## Shared brain (if you wire a cross-tool memory like gbrain)
- **A local file-based brain is fragile and unreachable by cloud agents.** A local embedded DB can corrupt, and a build agent on a *cloud* machine cannot reach a database that only exists as a file on your laptop. A hosted Postgres (e.g. Supabase) is the robust choice — every tool and machine hits the same live endpoint.
- **`init` may default to a different embedding provider/dimension than you want.** Switching providers later means editing config *and* `ALTER`-ing the vector column dimensions in the DB and rebuilding indexes — `init` does not retroactively change existing columns. Decide your embedding provider *before* indexing anything.
- **`embedding_disabled: true` does not stop `sync` from trying to embed.** If you intend lexical-only, pass `--no-embed` on sync; otherwise it will still attempt embeddings and fail without a key.
- **OpenCode Desktop runs a persistent backend that survives closing the window.** Closing/reopening reconnects to the *same* running backend, so it never re-reads MCP/config changes. To reload config you must **kill the process**, not just close the window.

## Execution agent (Factory Droid)
- **`droid exec -m` validates against the CLI's *built-in* model list, not the full platform roster.** A model can be selectable interactively (`/models`) yet rejected as `Invalid model` in non-interactive `droid exec` automation, because the published CLI hasn't caught up. Pin to a model the *installed* CLI accepts in `-m`, and re-check after every CLI bump.
- **`--worker-model` / `--validator-model` only apply with `--mission`.** A plain `droid exec -m <model>` is a *single* builder with no orchestration or validation — easy to run by accident and think you've got the mission stack when you don't.
- **`--mission` can stall on worker spawn with no error.** A long-lived multi-role process is a single point of stall: the lead prints "Created worktree" and then hangs on the worker handoff — no output, no failure, no progress. It's intermittent and can burn a run. The durable fix is not a retry loop; it's to **keep the mission *flow* but drop the single process** — drive `plan → build → validate → gate` from a script as separate single-model dispatches, each of which returns or fails fast. See [build-pipeline.md](build-pipeline.md) + [`templates/pipeline.sh`](../templates/pipeline.sh).

## Multi-tool coordination
- **Hand off work between agents via git branches, never the working tree.** When more than one agent works the same repo, coordinate *intent/status* on a shared board, but move *code* by committing to a task branch and pushing. Relying on uncommitted files in a shared folder is how you get clobbered work.
- **Personal `~/.<tool>/skills` directories do not reach cloud/remote runs.** Cloud sandboxes clone the *repo*, not your home dir. To make skills available in cloud execution, **commit them into the repo** (`.claude/`, `.cursor/`, `.agents/skills/`, `.factory/`), not just your global config.

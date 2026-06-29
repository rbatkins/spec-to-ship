#!/usr/bin/env bash
# spec-to-ship bootstrap (macOS / Linux / Git-Bash)
#
# This is an HONEST helper: it checks prerequisites and points you at the
# upstream install instructions for gstack and ponytail. It does NOT silently
# install third-party tools on your behalf — you should follow each project's
# own README so you get their latest, verified steps.
set -euo pipefail

say()  { printf '\n\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }

have() { command -v "$1" >/dev/null 2>&1; }

say "spec-to-ship bootstrap"
echo "A loop on top of gstack (Garry Tan) + ponytail (Dietrich Gebert). See CREDITS.md."

say "1. Checking prerequisites"
for tool in git node gh jq; do
  if have "$tool"; then ok "$tool found"; else warn "$tool NOT found — install it first"; fi
done

say "2. gstack  (planning personas + execution conductors)"
echo "   Repo:  https://github.com/garrytan/gstack"
if [ -d "$HOME/.claude/skills/gstack" ]; then
  ok "gstack appears installed at ~/.claude/skills/gstack"
  warn "On Windows, re-run gstack's ./setup after every 'git pull' (skills are COPIED, not symlinked)."
else
  warn "gstack not detected. Install it via its README, then re-run this script."
  echo "   Typical: clone the repo and run its ./setup for your host (e.g. claude)."
fi

say "3. ponytail  (the quality gate embedded in the build leg)"
echo "   Repo:  https://github.com/DietrichGebert/ponytail"
warn "Install ponytail per its README so the build gate is available to your agent."

say "4. (Optional) execution agent for the autonomous leg"
echo "   This repo documents the setup with Factory Droid (https://factory.ai),"
echo "   serving open-weight builders via Fireworks AI (US-based inference),"
echo "   gated by frontier reviewers. The loop itself is agent-agnostic."
if have droid; then ok "droid CLI found"; else warn "droid CLI not found (only needed for the documented execution leg)"; fi

say "Done."
echo "Next: open your AI coding tool and say —"
echo '   "Run the spec-to-ship loop on: <your one-line product idea>"'
echo "The agent follows flow/1..5. See examples/todo-app/ for a worked example."

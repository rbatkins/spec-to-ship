# spec-to-ship bootstrap (Windows / PowerShell)
#
# An HONEST helper: checks prerequisites and points you at the upstream install
# instructions for gstack and ponytail. It does NOT silently install third-party
# tools — follow each project's own README for their latest, verified steps.

function Say  ($m) { Write-Host "`n$m" -ForegroundColor White }
function Ok   ($m) { Write-Host "  [ok] $m" -ForegroundColor Green }
function Warn ($m) { Write-Host "  [! ] $m" -ForegroundColor Yellow }
function Have ($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }

Say "spec-to-ship bootstrap"
Write-Host "A loop on top of gstack (Garry Tan) + ponytail (Dietrich Gebert). See CREDITS.md."

Say "1. Checking prerequisites"
foreach ($tool in @('git','node','gh','jq')) {
  if (Have $tool) { Ok "$tool found" } else { Warn "$tool NOT found - install it first" }
}

Say "2. gstack  (planning personas + execution conductors)"
Write-Host "   Repo:  https://github.com/garrytan/gstack"
if (Test-Path "$HOME\.claude\skills\gstack") {
  Ok "gstack appears installed at ~\.claude\skills\gstack"
  Warn "On Windows, re-run gstack's ./setup after every 'git pull' (skills are COPIED, not symlinked)."
} else {
  Warn "gstack not detected. Install it via its README, then re-run this script."
}

Say "3. ponytail  (the quality gate embedded in the build leg)"
Write-Host "   Repo:  https://github.com/DietrichGebert/ponytail"
Warn "Install ponytail per its README so the build gate is available to your agent."

Say "4. (Optional) execution agent for the autonomous leg"
Write-Host "   Documented with Factory Droid (https://factory.ai), serving open-weight"
Write-Host "   builders via Fireworks AI (US-based inference), gated by frontier reviewers."
Write-Host "   The loop itself is agent-agnostic."
if (Have 'droid') { Ok "droid CLI found" } else { Warn "droid CLI not found (only needed for the documented execution leg)" }

Say "Done."
Write-Host 'Next: open your AI coding tool and say -'
Write-Host '   "Run the spec-to-ship loop on: <your one-line product idea>"'
Write-Host "The agent follows flow/1..5. See examples/todo-app/ for a worked example."

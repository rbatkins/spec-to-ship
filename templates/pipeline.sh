#!/usr/bin/env bash
# ============================================================================
# pipeline.sh — a deterministic multi-model build conductor (a mission-mode mimic).
#
# WHY THIS EXISTS
#   Native "mission" orchestration (a lead model that plans, workers that build,
#   a validator that checks) is the ideal shape — but a single long-lived
#   multi-role process can stall (worker-spawn RPC hangs are a known failure
#   mode; see docs/gotchas.md). This script rebuilds that same FLOW
#   (plan -> build -> validate -> gate) as a chain of RELIABLE single-model
#   dispatches, so it cannot hang and stays cheap. The script owns only the
#   MECHANICAL passing + looping; every REVIEW is a DIFFERENT model than the
#   builder; the two JUDGMENT gates (design-conformance + merge) are surfaced
#   to the author at the end, never automated away. It does NOT change product
#   behavior — it is pure build tooling.
#
#   Full rationale + the ownership map: docs/build-pipeline.md
#
# FLOW
#   [--arch]  PLANNER   plan  <prd>            -> plan.md   (reasoner; NEVER reviews its own plan)
#             BUILDER   build -f <prd> (+plan) -> branch    (cheap open-weight builder)
#   loop:     VALIDATOR validate(diff) -> VERDICT           (cheap pre-gate filter)
#               FIX-FIRST -> BUILDER fix(findings) -> re-validate   [all open-weight, no frontier]
#               PASS      -> break
#   gate:     codex + grok  (frontier, adversarial, independent of the builder)
#   -> STOP and surface: verdicts + "ready for author design-conformance + merge"
#
#   The script ENDS at the external gate. The two remaining reviews are JUDGMENT,
#   done by the human author, not the script:
#     1. DESIGN-CONFORMANCE (always): the author wrote the PRD/design, so only the
#        author can check the build against DESIGN INTENT — did it implement what
#        was specified, and where did it DRIFT. This is distinct from the code
#        reviewers (who judge the code on its own merits, not against the spec).
#     2. SECURITY review (if --sec): the author's implementation-security pass.
#   Then MERGE — also the author's call.
#
# Usage: pipeline.sh <lane-branch> <prd-path> [--arch] [--sec] [--max-fix N]
#   --arch      run the PLANNER decomposition pass first (architectural lanes only)
#   --sec       security-sensitive lane: mark the author security pass REQUIRED in the summary
#   --max-fix N max validator<->builder fix loops before surfacing (default 3)
#
# Configuration (env vars — the whole point is that every piece is swappable):
#   REPO            repo root to run in                      (default: current dir)
#   BASE            base branch to diff against              (default: main)
#   PLANNER_MODEL   reasoner for the --arch plan pass        (default: planner)
#   BUILDER_MODEL   cheap open-weight builder                (default: builder)
#   VALIDATOR_MODEL cheap reasoner for the pre-gate filter   (default: validator)
#   BUILD_CMD       how to dispatch a build/fix to an agent  (default: "droid exec")
#   PONYTAIL        path to the ponytail rules file          (default: auto-detect)
#
#   Model names are placeholders — set them to whatever your build agent accepts.
#   See docs/models-and-quality-gate.md for the role-by-role matrix this maps onto.
# ============================================================================
set -uo pipefail

LANE="${1:?usage: pipeline.sh <lane-branch> <prd-path> [--arch] [--sec] [--max-fix N]}"
PRD="${2:?missing <prd-path>}"
shift 2
ARCH=0; SEC=0; MAXFIX=3
while [ $# -gt 0 ]; do
  case "$1" in
    --arch) ARCH=1 ;;
    --sec)  SEC=1 ;;
    --max-fix) MAXFIX="$2"; shift ;;
    *) echo "unknown flag: $1" >&2; exit 2 ;;
  esac
  shift
done

REPO="${REPO:-$(pwd)}"
BASE="${BASE:-main}"
PLANNER_MODEL="${PLANNER_MODEL:-planner}"
BUILDER_MODEL="${BUILDER_MODEL:-builder}"
VALIDATOR_MODEL="${VALIDATOR_MODEL:-validator}"
BUILD_CMD="${BUILD_CMD:-droid exec}"

cd "$REPO" || { echo "no repo at $REPO" >&2; exit 1; }
[ -f "$PRD" ] || { echo "no PRD at $PRD" >&2; exit 1; }
WORK="$(mktemp -d)"

# ponytail rules feed the builder as a system prompt so the gate runs INSIDE the
# build (see docs/models-and-quality-gate.md). Override with PONYTAIL=/path/to/ponytail.md.
if [ -z "${PONYTAIL:-}" ]; then
  PONYTAIL="$(find "$HOME" -path '*ponytail*rules/ponytail.md' 2>/dev/null | sort | tail -1)"
fi
[ -f "${PONYTAIL:-/nonexistent}" ] || { echo "ponytail rules not found; set PONYTAIL=/path/to/ponytail.md" >&2; exit 1; }

log() { echo "[pipeline $(printf '%(%H:%M:%S)T' -1)] $*"; }
# Parse a machine-readable verdict from a review file. Reviewers are asked to end
# with a line "VERDICT: PASS" or "VERDICT: FIX-FIRST". Default to FIX-FIRST if
# absent (FAIL-CLOSED: an unparseable review never counts as a pass).
verdict() { grep -oiE "VERDICT:[[:space:]]*(PASS|FIX-FIRST|BLOCKER)" "$1" 2>/dev/null | head -1 | grep -oiE "PASS|FIX-FIRST|BLOCKER" | tr a-z A-Z || echo "FIX-FIRST"; }

# --- clean any stale worktree for this lane ---
git worktree remove "../$(basename "$REPO")-wt-$LANE" --force 2>/dev/null || true
git worktree prune

# --- [--arch] planning pass: PLANNER (reasoner). It PLANS; it will NOT review its own plan later. ---
PLAN_ARG=""
if [ "$ARCH" = "1" ]; then
  log "PLAN: $PLANNER_MODEL decomposing $PRD"
  {
    echo "You are the ARCHITECT. Read this PRD and produce a concrete build PLAN: file-by-file"
    echo "decomposition, the migration(s), the data-model changes, the test list, and the ORDER"
    echo "to build in. Do NOT write code. Name the failure modes to design against. Be concrete."
    echo "=== PRD ==="; cat "$PRD"
  } > "$WORK/plan-prompt.txt"
  $BUILD_CMD --auto low -m "$PLANNER_MODEL" -f "$WORK/plan-prompt.txt" > "$WORK/plan.md" 2>&1
  PLAN_ARG="$WORK/plan.md"
  log "PLAN done ($(wc -l < "$WORK/plan.md") lines) -> $WORK/plan.md"
fi

# --- BUILD: BUILDER (cheap open-weight). ponytail rules ride along as a system prompt. ---
log "BUILD: $BUILDER_MODEL on $LANE"
BUILD_SPEC="$PRD"
if [ -n "$PLAN_ARG" ]; then
  cat "$PRD" "$WORK/plan.md" > "$WORK/build-spec.md"
  BUILD_SPEC="$WORK/build-spec.md"
fi
$BUILD_CMD --auto high -m "$BUILDER_MODEL" -w "$LANE" -f "$BUILD_SPEC" --append-system-prompt-file "$PONYTAIL" > "$WORK/build.log" 2>&1
log "BUILD done:"; tail -3 "$WORK/build.log"

# --- VALIDATE loop: VALIDATOR (cheap pre-gate reasoner), auto-loop fixes back to the BUILDER ---
i=0
while [ "$i" -lt "$MAXFIX" ]; do
  i=$((i+1))
  log "VALIDATE round $i: $VALIDATOR_MODEL on the diff"
  {
    echo "Adversarial PRE-GATE validation of a build. Read the PRD then the full diff vs $BASE."
    echo "Find REAL defects only: correctness bugs, security/scope holes, missing tests, contract"
    echo "mismatches, over-engineering (ponytail). This is a CHEAP filter BEFORE the frontier gate;"
    echo "be strict but only on real issues. END your output with exactly one line:"
    echo "  VERDICT: PASS      (no blocking issues)"
    echo "  VERDICT: FIX-FIRST (blocking issues — list them numbered above with file:line)"
    echo "=== PRD ==="; cat "$PRD"
    echo "=== DIFF ==="; git diff "$BASE...$LANE"
  } > "$WORK/validate-prompt.txt"
  $BUILD_CMD --auto low -m "$VALIDATOR_MODEL" -f "$WORK/validate-prompt.txt" > "$WORK/validate-$i.txt" 2>&1
  V="$(verdict "$WORK/validate-$i.txt")"
  log "  validator verdict: $V"
  [ "$V" = "PASS" ] && break
  if [ "$i" -ge "$MAXFIX" ]; then log "  max fix loops reached — surfacing with validator findings unresolved"; break; fi
  log "  FIX: $BUILDER_MODEL addressing validator findings (round $i)"
  {
    echo "# Fix round $i — address the pre-gate validator findings VERBATIM. Work on branch $LANE."
    echo "Fix exactly these; laziest correct diff; keep all gates green. Commit 'fix-$i:'."
    echo "=== VALIDATOR FINDINGS ==="; cat "$WORK/validate-$i.txt"
  } > "$WORK/fix-$i.md"
  $BUILD_CMD --auto high -m "$BUILDER_MODEL" -w "$LANE" -f "$WORK/fix-$i.md" --append-system-prompt-file "$PONYTAIL" > "$WORK/fix-$i.log" 2>&1
done

# --- EXTERNAL GATE: codex + grok (frontier, adversarial, DIFFERENT models than the builder) ---
{
  echo "Adversarial code review. Read the PRD then the full diff vs $BASE. Find BLOCKER/MAJOR/MINOR"
  echo "issues (correctness, security/scope, missing tests, over-engineering). END with exactly:"
  echo "  VERDICT: PASS  or  VERDICT: FIX-FIRST"
  echo "=== PRD ==="; cat "$PRD"
  echo "=== DIFF ==="; git diff "$BASE...$LANE"
} > "$WORK/gate-prompt.txt"
log "GATE: codex"
codex exec --skip-git-repo-check < "$WORK/gate-prompt.txt" > "$WORK/gate-codex.txt" 2>&1 || true
log "  codex verdict: $(verdict "$WORK/gate-codex.txt")"
log "GATE: grok"
grok --prompt-file "$WORK/gate-prompt.txt" --output-format plain > "$WORK/gate-grok.txt" 2>/dev/null || true
log "  grok verdict: $(verdict "$WORK/gate-grok.txt")"

# --- SURFACE: stop here. The two remaining reviews are JUDGMENT, done by the author, not the script.
echo
echo "======================= PIPELINE SUMMARY: $LANE ======================="
echo "  build:            $(tail -1 "$WORK/build.log" 2>/dev/null | head -c 80)"
echo "  validator (final):$(verdict "$WORK/validate-$i.txt")   (round $i of max $MAXFIX)  [code quality]"
echo "  codex:            $(verdict "$WORK/gate-codex.txt")   [frontier, code]"
echo "  grok:             $(verdict "$WORK/gate-grok.txt")   [frontier, code]"
echo "  security lane:    $([ "$SEC" = 1 ] && echo 'YES' || echo 'no')"
echo "  artifacts:        $WORK/{plan.md,validate-*.txt,gate-codex.txt,gate-grok.txt}"
echo "  ---- NEXT (author judgment — the script CANNOT do these) ----"
echo "  [ALWAYS] DESIGN-CONFORMANCE: diff  vs  $PRD  — did the build match the design intent? where did it drift?"
echo "  $([ "$SEC" = 1 ] && echo '[REQUIRED] SECURITY review: author implementation-security pass' || echo '[n/a] security pass not required for this lane')"
echo "  [THEN]   MERGE decision"
echo "======================================================================="
echo "PIPELINE-DONE lane=$LANE work=$WORK"

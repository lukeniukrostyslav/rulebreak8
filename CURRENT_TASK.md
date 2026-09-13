# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with real challenge modules.

## Completed in this checkpoint
- Added `docs/ARCHITECTURE.md` with runtime boundaries and MVP rules.
- Added `scripts/core/challenge_manager.gd` as the reusable challenge source of truth.
- Added `scripts/core/progression.gd` for local streak/stat persistence.
- Added `scripts/data/challenges.json` with the canonical 20-challenge MVP seed across SEE, REMEMBER, REACT, SWITCH, TRICK and MIX.
- Added `docs/BUILD_AND_TEST.md` with development and release gates.

## Immediate sequence
1. Integrate ChallengeManager and Progression into the live game scene.
2. Replace the current four hard-coded buttons with challenge-family implementations.
3. Implement SEE, REMEMBER, REACT, SWITCH, TRICK and MIX modules.
4. Build main menu, gameplay, result and stats/settings surfaces.
5. Add tactile/audio/animation feedback while preserving minimal visual design.
6. Add automated/deterministic tests and verify restart behavior.
7. Configure Android export and produce a test build.
8. Run a release-readiness audit before any Google Play submission.

## Current blockers
None known at repository level.

External actions will eventually be required for Android device testing and Google Play account/release steps. Do not mark those as complete until actually performed.

## Last checkpoint
Core architecture, challenge catalog, local progression and build/test gates are now documented and committed.

## Next checkpoint requirement
After the next substantial implementation session, update this file with actual completed files/features and verified test/build results.

# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD

## Current mission
Turn the existing Godot foundation into a commercially credible, testable RULEBREAK MVP without claiming runtime or Android readiness before it is verified.

## Completed in the current checkpoint
- Live game loop uses `ChallengeManager` and `Progression`.
- 20-challenge engineering catalog spans SEE, REMEMBER, REACT, SWITCH, TRICK and MIX.
- `ChallengeView` contains implementations for all six families.
- Rule-switch spoiler was removed from the pre-input UI.
- Deterministic `ChallengeManager` smoke test exists at `tests/test_challenge_manager.gd`.
- `docs/BUILD_AND_TEST.md` defines development and release gates.
- Local progression save/load was hardened against missing/unopenable files, invalid JSON values and inconsistent best-streak data.
- README and project state were refreshed to match the current repository rather than the earlier foundation-only snapshot.

## Immediate sequence
1. Tighten weak challenge semantics: especially `sound_switch`, `mixed`, and timing challenges.
2. Remove or localize remaining hard-coded player-facing strings in `ChallengeView`.
3. Verify the 20 challenge definitions against their visual presentation and correct indexes.
4. Add/strengthen deterministic tests where they can run without a device or editor UI.
5. Inspect Android export configuration and add only verified, non-secret project configuration; never commit release credentials.
6. Run Godot parse/smoke tests when a Godot runtime is available.
7. Run physical Android touch/layout/restart testing.
8. Expand content from the 20-challenge engineering catalog toward the 100-challenge commercial target.
9. Perform a release-readiness audit before any Google Play submission.

## Current blockers
- Godot runtime is not available in the current execution environment, so the deterministic test and gameplay runtime remain NOT VERIFIED here.
- No Android export preset has been verified in the repository yet.
- Physical Android device testing has not been performed.
- Release signing and Google Play account actions are external owner actions and must remain unclaimed until completed.

## Truth rule
Never claim a feature, test, build, device run or release step is complete unless repository evidence or an actual execution result verifies it. Management percentages are estimates only.

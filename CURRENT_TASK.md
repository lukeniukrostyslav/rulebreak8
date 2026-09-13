# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with real challenge modules and a verifiable Android release path.

## Verified in this checkpoint
- GitHub Actions run `34754337567` on commit `c52a440c5d5dd520637f976211367bbd92c95222` completed successfully.
- Godot 4.3 stable was downloaded and executed in CI.
- The deterministic `tests/test_challenge_manager.gd` test completed with `RULEBREAK ChallengeManager tests: PASS`.
- The previous CSV quoting defect in `locale/challenges.csv` was corrected and the test still passes on the corrected commit.

## Important verification caveat
- The CI log still reports `No loader found for resource: res://locale/*.csv` during the headless editor/import step, followed by `Failed loading resource` warnings when the deterministic test starts.
- The workflow nevertheless exits successfully because the import command returns exit code 0 and the ChallengeManager test does not depend on loading the imported translation resources.
- Therefore localization import/runtime is **NOT VERIFIED** yet. This is now an explicit follow-up item rather than being treated as a passing localization gate.

## Completed in this checkpoint
- Live ChallengeManager and Progression are integrated into the game loop.
- ChallengeView implements all six challenge families: SEE, REMEMBER, REACT, SWITCH, TRICK and MIX.
- Hardened local progression parsing/writing against malformed save state.
- Added deterministic ChallengeManager smoke test and verified it in GitHub Actions.
- Improved reaction challenges so the player sees the prerequisite signal before the response window.
- Reworked MIX into a coherent SEE → SWITCH → REACT sequence with four positional answers.
- Removed the misleading "sound" behavior from the visible instruction; the current `sound_switch` catalog item is treated as a visual signal-switch placeholder until real audio is implemented.
- Added `export_presets.cfg` with a credentials-free Android Debug preset targeting arm64.
- Added credentials-free GitHub Actions verification workflow pinned to Godot 4.3 stable.

## Immediate sequence
1. Fix and explicitly verify Godot CSV translation import in CI; the current workflow must not count the existing loader warnings as localization success.
2. Audit and localize remaining hardcoded ChallengeView strings.
3. Replace the visual `sound_switch` placeholder with a real audio-driven mechanic, or formally rename/reclassify it before content lock.
4. Add stronger deterministic tests for challenge timing/state transitions where feasible.
5. Validate the Android debug export preset with Godot 4.3 in a Godot-capable environment.
6. Execute Godot runtime tests when a Godot-capable environment is available.
7. Test touch input, portrait layouts, persistence restart and all 20 challenges on a physical Android device.
8. Prepare AAB/release signing outside the repository and run the final release-readiness audit.

## Current blockers
No repository-level blocker for the deterministic logic test. Localization import/runtime verification is currently **BLOCKED / NOT VERIFIED** by the headless import behavior and must be resolved before claiming 21-locale runtime readiness. Android export/device testing and release signing remain unverified.

## Truth rule
Never claim a feature is runtime-tested, Android-built, signed, localization-verified, or Play-ready unless there is direct evidence from the actual tool/build/device result.

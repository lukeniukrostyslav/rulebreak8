# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with real challenge modules and a verifiable Android release path.

## Completed in this checkpoint
- Live ChallengeManager and Progression are integrated into the game loop.
- ChallengeView implements all six challenge families: SEE, REMEMBER, REACT, SWITCH, TRICK and MIX.
- Hardened local progression parsing/writing against malformed save state.
- Added deterministic ChallengeManager smoke test; runtime execution remains unverified because Godot is not available in this environment.
- Improved reaction challenges so the player sees the prerequisite signal before the response window.
- Reworked MIX into a coherent SEE → SWITCH → REACT sequence with four positional answers.
- Removed the misleading "sound" behavior from the visible instruction; the current `sound_switch` catalog item is now treated as a visual signal-switch placeholder until real audio is implemented.
- Updated README and project-state documentation to reflect actual verification status.
- Added `export_presets.cfg` with a credentials-free Android Debug preset targeting arm64, so the project now has a repository-level Android export configuration without release secrets.
- Added `.github/workflows/godot.yml`, a credentials-free GitHub Actions verification workflow pinned to Godot 4.3 stable. It performs headless project import validation and runs the deterministic ChallengeManager test.
- Documented the CI verification gate in `docs/BUILD_AND_TEST.md`.

## Immediate sequence
1. Inspect the first GitHub Actions run and record its real result; do not treat workflow creation as a passing test.
2. Audit and localize remaining hardcoded ChallengeView strings.
3. Replace the visual `sound_switch` placeholder with a real audio-driven mechanic, or formally rename/reclassify it before content lock.
4. Add stronger deterministic tests for challenge timing/state transitions where feasible.
5. Validate the Android debug export preset with Godot 4.3 in a Godot-capable environment.
6. Execute Godot headless/runtime tests when a Godot-capable environment is available.
7. Test touch input, portrait layouts, persistence restart and all 20 challenges on a physical Android device.
8. Prepare AAB/release signing outside the repository and run the final release-readiness audit.

## Current blockers
No repository-level blocker. Runtime verification and Android export execution remain blocked by the absence of a Godot executable in the current environment. Release signing remains intentionally outside the repository. CI result must be checked separately after the workflow executes.

## Truth rule
Never claim a feature is runtime-tested, Android-built, signed, or Play-ready unless there is direct evidence from the actual tool/build/device result.

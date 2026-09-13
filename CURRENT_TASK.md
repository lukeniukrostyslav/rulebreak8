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

## Immediate sequence
1. Audit and localize remaining hardcoded ChallengeView strings.
2. Replace the visual `sound_switch` placeholder with a real audio-driven mechanic, or formally rename/reclassify it before content lock.
3. Add stronger deterministic tests for challenge timing/state transitions where feasible.
4. Add a safe Android debug export preset/configuration without committing release credentials.
5. Execute Godot headless/runtime tests when a Godot-capable environment is available.
6. Test touch input, portrait layouts, persistence restart and all 20 challenges on a physical Android device.
7. Prepare AAB/release signing outside the repository and run the final release-readiness audit.

## Current blockers
No repository-level blocker. Runtime verification is blocked by the absence of a Godot executable in the current environment.

## Truth rule
Never claim a feature is runtime-tested, Android-built, signed, or Play-ready unless there is direct evidence from the actual tool/build/device result.

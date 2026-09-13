# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with real challenge modules and a verifiable Android release path.

## Verified in this checkpoint
- The repository contains the deterministic ChallengeManager and ChallengeView tests.
- The previous CI run `34754337567` passed the deterministic ChallengeManager gate.
- The project targets Godot 4.3 stable and has a credentials-free Android arm64 debug export preset.

## Localization correction in progress
- The previous approach referenced 84 generated `.translation` files that are not committed to the repository and therefore could not be a reliable clean-checkout runtime path.
- Replaced that approach with a repository-owned runtime CSV localization loader in `scripts/core/localization.gd`.
- The loader parses the four committed CSV sources, builds one Godot `Translation` resource per locale at runtime, registers all 21 locales with `TranslationServer`, and selects a supported system locale with English fallback.
- `project.godot` now autoloads `Localization` and no longer references nonexistent generated translation resources.
- `tests/test_localization.gd` now verifies all 21 locales and representative runtime translations.
- GitHub Actions now tests runtime CSV localization rather than counting generated import artifacts.
- The new CI run for commit `99e6dcf9e0a2f9368108af30d471cb594bb6c37f` is currently **IN PROGRESS**; localization is not marked VERIFIED until that run completes successfully.

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
- Reworked localization to a deterministic runtime CSV path and added its automated gate.

## Immediate sequence
1. Finish CI verification of runtime CSV localization.
2. Audit and localize remaining hardcoded ChallengeView strings.
3. Replace the visual `sound_switch` placeholder with a real audio-driven mechanic, or formally rename/reclassify it before content lock.
4. Add stronger deterministic tests for challenge timing/state transitions where feasible.
5. Validate the Android debug export preset with Godot 4.3 in a Godot-capable environment.
6. Execute Godot runtime tests when a Godot-capable environment is available.
7. Test touch input, portrait layouts, persistence restart and all 20 challenges on a physical Android device.
8. Prepare AAB/release signing outside the repository and run the final release-readiness audit.

## Current blockers
No repository-level blocker for the deterministic logic tests. Runtime localization verification is **IN PROGRESS** pending CI result. Android export/device testing and release signing remain unverified.

## Truth rule
Never claim a feature is runtime-tested, Android-built, signed, localization-verified, or Play-ready unless there is direct evidence from the actual tool/build/device result.

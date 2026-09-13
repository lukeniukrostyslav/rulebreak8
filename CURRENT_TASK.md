# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with 100 real challenge entries and a verifiable Android release path.

## Latest checkpoint
- `ChallengeManager` now contains exactly 100 catalog entries: 20 original + 80 extended.
- Fixed the manager's missing explicit `index` declaration.
- Updated the deterministic manager test to require 100 levels, validate all six families and verify level-100 wraparound.
- GitHub Actions run `34784210063` for commit `2741183d41ef4342845f9d70ea44b4b970ba42d6` is currently **IN PROGRESS**. Do not mark the new gate VERIFIED until it finishes successfully.
- Existing verified Android Debug Release: `v0.1.0-debug.79`, asset `rulebreak-debug.apk`; this is a debug APK, not a signed Google Play AAB.

## Completed / present
- ChallengeManager + Progression integrated into the game loop.
- ChallengeView implements SEE, REMEMBER, REACT, SWITCH, TRICK and MIX.
- Local progression parsing/writing hardened.
- Deterministic ChallengeManager and ChallengeView tests exist.
- Runtime CSV localization path exists for 21 locales; latest CI result must be checked before calling localization VERIFIED.
- Credentials-free Android arm64 Debug export preset exists.
- Godot 4.3 GitHub Actions verification workflow exists.
- 100-level challenge catalog is now the content target.

## Immediate sequence
1. Finish/inspect the current 100-level CI run.
2. Audit remaining hardcoded ChallengeView strings and localization coverage.
3. Replace or formally reclassify the visual `sound_switch` placeholder.
4. Strengthen timing/state tests where useful.
5. Validate the Android export from the current main commit and inspect the APK.
6. Run Godot runtime tests in a Godot-capable environment.
7. Physical-device test touch, portrait layout, persistence/restart and all 100 levels.
8. Prepare signed AAB and final Google Play readiness audit.

## Current blockers
- Current 100-level CI run: **IN PROGRESS**.
- Physical Android device validation: unverified.
- Google Play signing/AAB: OWNER ACTION when signing credentials and Play Console access are required.

## Truth rule
Never claim runtime-tested, Android-built, signed, localization-verified, or Play-ready without direct evidence from the actual tool/build/device result.

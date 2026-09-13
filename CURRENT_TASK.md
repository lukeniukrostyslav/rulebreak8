# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with 100 real challenge entries and a verifiable Android release path.

## Latest checkpoint
- `ChallengeManager` contains exactly 100 catalog entries: 20 original + 80 extended.
- Extended runtime rendering is routed through `ChallengeViewV2` with family-specific variants.
- The manager gate now validates all six families and requires every catalog entry to satisfy the view support contract.
- An independent CI workflow now validates the Android unsigned release AAB path.
- Existing verified Android Debug Release: `v0.1.0-debug.79`, asset `rulebreak-debug.apk`; this is a debug APK, not a signed Google Play AAB.

## Completed / present
- ChallengeManager + Progression integrated into the game loop.
- ChallengeView implements SEE, REMEMBER, REACT, SWITCH, TRICK and MIX; expanded renderer is active through `game_bootstrap.gd`.
- Local progression parsing/writing hardened.
- Deterministic ChallengeManager and ChallengeView tests exist.
- Runtime CSV localization path exists for 21 locales; extended rules have an explicit English fallback layer so raw keys are not shown.
- Credentials-free Android arm64 Debug export preset exists.
- Unsigned Android Release AAB export preset and CI gate exist.
- Godot 4.3 GitHub Actions verification workflow exists.
- 100-level challenge catalog is now the content target.

## Immediate sequence
1. Verify the new CI runs for the current commits.
2. Validate all 100 catalog entries against ChallengeView support and English localization fallbacks.
3. Verify the Android debug APK and unsigned release AAB in CI.
4. Run Godot runtime tests in a Godot-capable environment.
5. Physical-device test touch, portrait layout, persistence/restart and all 100 levels.
6. Prepare signed AAB and final Google Play readiness audit.

## Current blockers
- CI verification for the new commits is pending.
- Physical Android device validation: unverified.
- Google Play signing/AAB: OWNER ACTION when signing credentials and Play Console access are required.

## Truth rule
Never claim runtime-tested, Android-built, signed, localization-verified, or Play-ready without direct evidence from the actual tool/build/device result.

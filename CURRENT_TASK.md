# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD — release candidate hardening

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with 100 challenge entries and a verifiable Android release path.

## Latest verified checkpoint
- Source `34e218e0f8e4f338e70937029b58529eed8c4578` is verified GREEN for the current release-candidate hardening pass.
- Android verification run `34835983629` passed repository integrity, Godot 4.3 headless runtime tests, localization preparation, Debug APK export, upload and GitHub Release publication.
- Android release artifact verification run `34835983641` passed repository integrity, runtime gates, localization preparation, unsigned Release AAB export and artifact upload.
- Progression persistence tests now prove that a structurally truncated/invalid primary save is recovered from the known-good backup instead of silently resetting progress.
- The permanent GDScript 4.3 type-inference fix in `challenge_view_v2.gd` was verified by the clean Android runs.
- Temporary `.github/workflows/gdscript-type-fix.yml` has been removed after verification.
- The AAB remains intentionally unsigned and is not Google Play-ready.

## Completed / present
- ChallengeManager + Progression integrated into the game loop.
- ChallengeView implements SEE, REMEMBER, REACT, SWITCH, TRICK and MIX; expanded renderer is active through the canonical game controller.
- Local progression parsing/writing hardened with required-save-structure validation, backup recovery, current-level bounds and streak invariants.
- Deterministic ChallengeManager, ChallengeView, localization, rule-fallback and Progression tests exist and passed in the latest Android runtime gate.
- Runtime CSV localization path exists for 21 locales; extended rules have an explicit English fallback layer so raw keys are not intentionally shown.
- Credentials-free Android arm64 Debug export preset and unsigned Release AAB preset exist and have passed clean CI verification.
- Godot 4.3 GitHub Actions verification and independent AAB verification workflows exist.
- 100-level challenge catalog is the content target and is guarded by static and runtime contracts.

## Immediate sequence
1. Continue automated semantic checks only where they materially improve confidence without expanding MVP scope.
2. Finish production-quality UI/visual polish and audio/haptic feedback where feasible without external device access.
3. Perform physical-device testing: touch, portrait layout, persistence/restart and all 100 levels.
4. Prepare production signing and complete the Google Play readiness audit.
5. Capture final store assets and run the signed AAB through an owner-side Play testing track.

## Current blockers
- Physical Android device validation: unverified in this execution environment.
- Production signing and Google Play submission: OWNER ACTION when signing credentials and Play Console access are required.
- Full audio/visual polish remains incomplete.

## Truth rule
Never claim runtime-tested, Android-built, signed, localization-verified, or Play-ready without direct evidence from the actual tool/build/device result.

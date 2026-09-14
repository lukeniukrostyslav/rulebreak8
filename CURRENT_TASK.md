# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD — release candidate hardening

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with 100 real challenge entries and a verifiable Android release path.

## Latest verified checkpoint
- Commit `32cadfef545c62cb494bb9a07b9502ab21a2510f` passed the `Godot 4.3 verification` GitHub Actions job.
- The verification job passed repository integrity, Godot headless runtime tests, localization generation, Android Debug APK export, APK validation and GitHub Release publication.
- The same commit passed the independent `Android release artifact verification` job.
- The AAB job passed repository integrity, Godot runtime gates, localization generation and unsigned Android Release AAB export/validation/upload.
- These are CI-verified artifacts. The AAB is intentionally unsigned and is not Google Play-ready.

## Completed / present
- ChallengeManager + Progression integrated into the game loop.
- ChallengeView implements SEE, REMEMBER, REACT, SWITCH, TRICK and MIX; expanded renderer is active through the canonical game controller.
- Local progression parsing/writing hardened.
- Deterministic ChallengeManager and ChallengeView tests exist and now pass in Godot headless CI.
- Runtime CSV localization path exists for 21 locales; extended rules have an explicit English fallback layer so raw keys are not shown.
- Credentials-free Android arm64 Debug export preset exists and now exports successfully in CI.
- Unsigned Android Release AAB export preset and CI gate exist and now export successfully in CI.
- Godot 4.3 GitHub Actions verification workflow exists and is GREEN on the latest hardening commit.
- 100-level challenge catalog is the content target and passes the repository/runtime gates.

## Immediate sequence
1. Obtain and inspect the CI APK and unsigned AAB artifacts as release evidence.
2. Add/strengthen automated catalog-to-renderer contract checks where useful, without changing the locked product scope.
3. Perform physical-device testing: touch, portrait layout, persistence/restart and all 100 levels.
4. Finish production-quality audio/haptics/feedback and visual polish.
5. Prepare production signing and complete the Google Play readiness audit.

## Current blockers
- Physical Android device validation: unverified in this execution environment.
- Production signing and Google Play submission: OWNER ACTION when signing credentials and Play Console access are required.
- Full audio/visual polish remains incomplete.

## Truth rule
Never claim runtime-tested, Android-built, signed, localization-verified, or Play-ready without direct evidence from the actual tool/build/device result.

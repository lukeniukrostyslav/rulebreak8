# RULEBREAK — CURRENT TASK

## Status
ACTIVE

## Phase
ENGINEERING / MVP BUILD — release candidate hardening

## Current mission
Turn the existing Godot foundation into a reusable, testable RULEBREAK game loop with 100 challenge entries and a verifiable Android release path.

## Latest verified checkpoint
- Commit `32cadfef545c62cb494bb9a07b9502ab21a2510f` is the latest checkpoint recorded as fully GREEN in project history.
- That verification passed repository integrity, Godot headless runtime tests, localization generation, Android Debug APK export, APK validation and GitHub Release publication.
- The same checkpoint passed the independent Android release artifact verification job with unsigned Release AAB export/validation.
- The AAB is intentionally unsigned and is not Google Play-ready.

## New hardening work pending CI verification
- Progression runtime persistence/invariant gate is included in both Android verification workflows.
- Static integrity now cross-checks the 20 seed entries against runtime manager family/choice/correct-index semantics.
- ChallengeView runtime coverage now checks renderer support for all 100 catalog entries and explicit contracts for representative extended SWITCH/REACT challenges.
- Extended `react_late` renderer contract is explicitly aligned to `LATE`.
- Build/test documentation now records the expanded verification gates.

Current unverified head commits are intentionally not described as GREEN until the corresponding GitHub Actions runs finish successfully.

## Completed / present
- ChallengeManager + Progression integrated into the game loop.
- ChallengeView implements SEE, REMEMBER, REACT, SWITCH, TRICK and MIX; expanded renderer is active through the canonical game controller.
- Local progression parsing/writing hardened with current-level and streak invariants.
- Deterministic ChallengeManager, ChallengeView, localization, rule-fallback and Progression tests exist.
- Runtime CSV localization path exists for 21 locales; extended rules have an explicit English fallback layer so raw keys are not intentionally shown.
- Credentials-free Android arm64 Debug export preset and unsigned Release AAB preset exist.
- Godot 4.3 GitHub Actions verification and independent AAB verification workflows exist.
- 100-level challenge catalog is the content target and is guarded by static and runtime contracts.

## Immediate sequence
1. Complete CI verification for the latest hardening head and inspect APK/AAB artifacts.
2. Continue automated catalog/rendering semantic checks where they improve confidence without expanding MVP scope.
3. Perform physical-device testing: touch, portrait layout, persistence/restart and all 100 levels.
4. Finish production-quality audio/haptics/feedback and visual polish.
5. Prepare production signing and complete the Google Play readiness audit.

## Current blockers
- Physical Android device validation: unverified in this execution environment.
- Production signing and Google Play submission: OWNER ACTION when signing credentials and Play Console access are required.
- Full audio/visual polish remains incomplete.

## Truth rule
Never claim runtime-tested, Android-built, signed, localization-verified, or Play-ready without direct evidence from the actual tool/build/device result.

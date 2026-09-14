# RULEBREAK — CURRENT TASK

## Current phase
ENGINEERING / MVP BUILD — release candidate hardening

## Current task
Finish the local/CI commercial-readiness pass without expanding the MVP scope, then hand the verified build to owner-side physical Android and release checks.

## Completed in the current hardening pass — 2026-09-14
- Re-audited the current repository state.
- Re-ran the repository-only static integrity gate successfully.
- Removed obsolete duplicate `scripts/core/challenge_view.gd`; `challenge_view_v2.gd` is canonical.
- Hardened `Progression` persistence with durable previous-save backup rotation.
- Added safe temporary backup rotation so a failed replacement can restore the previous primary save.
- Added strict typed payload validation for persisted progression state.
- Added regression coverage for corrupted/truncated/typed-invalid progression payloads.
- Strengthened persistence tests to verify backup rotation contents and restoration of the primary save.
- Extended the static integrity gate to enforce the canonical renderer, persistence recovery and localized-rule fallback contracts.
- Integrated lightweight procedural answer audio feedback and bounded its generator buffer writes.
- Added deterministic UI contract coverage for the canonical renderer, four-choice input, logical answer locking, haptics, audio feedback and portrait viewport configuration.
- Aligned the UI contract test with the current typed responsive layout syntax instead of weakening the production code contract.
- Polished the gameplay UI hierarchy with a dedicated rule panel, depth/shadow treatment for answer controls, stronger text hierarchy and clearer mobile touch-state styling.
- Added animated answer feedback so correct/wrong responses have immediate visual acknowledgement alongside existing haptic/audio feedback.
- Added a dedicated main-scene boot smoke gate.
- Added all-100-level catalog behavior verification through the public `ChallengeManager.check()` contract.
- Found and fixed a Godot 4.3 parser error in responsive grid spacing; added an explicit critical-GDScript compile gate so this class of failure is caught before export.
- Added English localization fallback coverage for all 100 catalog entries.
- Added explicit runtime coverage for translated base rules, English extended-rule fallback and the defensive `rule_switch` fallback path.
- Added a headless audio feedback smoke test using the Dummy audio driver.
- Removed a duplicate Android release preset option.
- Added an end-to-end headless gameplay-loop smoke test covering main-scene boot, correct answer progression, persistence, input lock, timed readiness and wrong-answer retry behavior.
- Fixed the gameplay smoke test's timing assumption: `answer_locked` is an immediate synchronous guard while the public answer handler completes its feedback/advance path asynchronously. The test now checks the immediate lock before waiting for the next challenge.
- Added explicit scene cleanup to the gameplay smoke test so its own CanvasItem/ObjectDB lifecycle does not obscure real regressions with avoidable leak warnings.
- Integrated compile, gameplay, localization fallback and audio gates into the main Android verification workflow.
- Integrated the same gates into the unsigned AAB verification workflow.
- Added release-readiness, artifact identity, signing-boundary, evidence-matrix and GO/NO-GO documentation.
- Added a repository-level release contract gate covering project identity, Android export settings, arm64-only release architecture, 100-level catalog integrity and offline runtime boundaries.
- Integrated the release contract gate before the Android export stage in the main Godot verification workflow.
- Added distinct timeout audio feedback so a missed timed challenge is acoustically different from an ordinary wrong answer.
- Extended the audio smoke test to cover correct, wrong and timeout feedback.
- Added a Google Play store listing draft with claims constrained to the current MVP design.
- Added an engineering Data Safety review documenting the offline/local-data boundary and the owner-side Play Console boundary.
- Added a physical Android QA checklist covering installation, portrait touch UX, all 100 levels, persistence, audio/haptics, localization, airplane mode and crash/ANR smoke.
- Added an immutable physical Android QA record template requiring the tested APK SHA-256 and exact source commit SHA.
- Extended release documentation tests so the physical QA evidence record itself is part of the release-documentation contract.

## Current verification target
Current `main` head is the latest hardening commit. GitHub Actions has been triggered for the current branch; the authoritative result must be read from the exact current SHA, not inherited from an older release-candidate SHA.

The authoritative release gate requires the current SHA itself to pass critical compile, static integrity, release contract, catalog behavior, localization fallback, audio, main-scene boot, end-to-end gameplay, Debug APK export and unsigned Release AAB export.

## Next safe work
1. Inspect the current-head Android verification and unsigned AAB results; if any gate fails, diagnose from the exact current SHA and fix immediately.
2. Continue production-quality visual/audio/haptic polish only where it can be validated without external device access.
3. Harden release metadata and store-asset preparation without inventing owner-side evidence.
4. Perform physical-device testing: touch, portrait layout, persistence/restart, haptics and all 100 levels.
5. Prepare production signing and complete the Google Play readiness audit.
6. Capture final store assets and run the signed AAB through an owner-side Play testing track.

## Verification truth
- Existing current-head UI contract run `34871385247`: PASS on its recorded source SHA.
- Existing clean Android verification run `34835983629`: PASS on the earlier verified release-candidate source.
- Existing clean unsigned Release AAB run `34835983641`: PASS on the earlier verified release-candidate source.
- New release contract gate is committed and is now part of the main Android verification workflow.
- New timeout audio behavior and its smoke coverage are committed; current-head runtime verification remains pending until CI completes.
- The previous current-head Android run failed only at the gameplay smoke assertion because the test expected the asynchronous answer handler to remain locked after its 350 ms feedback delay. That test contract has now been corrected to check the immediate synchronous lock and then verify the completed transition.
- Current-head Android/AAB verification must not be described as GREEN until the new gate and all existing gates pass on the exact current SHA.
- Physical Android QA: NOT VERIFIED in this environment.
- Production signing: OWNER ACTION.
- Google Play Console release: OWNER ACTION.

## Do not
- Do not add backend/network dependencies to the MVP.
- Do not add ads, subscriptions or IAP unless the product decision is explicitly changed.
- Do not claim physical Android or Play verification without direct evidence.
- Do not reset or recreate the project.

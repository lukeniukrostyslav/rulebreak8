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
- Integrated compile, gameplay, localization fallback and audio gates into the main Android verification workflow.
- Integrated the same gates into the unsigned AAB verification workflow.
- Synchronized README, QA-gate documentation, build status and project state with the current engineering truth.

## Current verification target
Current `main` head: `a68a929b17b6046db5802403db55517b69e8fae5`.

This head contains the end-to-end gameplay smoke gate and its integration into both Android verification pipelines. The current Android Debug and unsigned AAB runs must complete before this head becomes the next authoritative verified release-candidate source.

## Next safe work
1. Inspect the current-head Android verification and unsigned AAB results; if any gate fails, diagnose from the exact current SHA and fix immediately.
2. Continue production-quality visual/audio/haptic polish only where it can be validated without external device access.
3. Perform physical-device testing: touch, portrait layout, persistence/restart, haptics and all 100 levels.
4. Prepare production signing and complete the Google Play readiness audit.
5. Capture final store assets and run the signed AAB through an owner-side Play testing track.

## Verification truth
- Existing clean Android verification run `34835983629`: PASS on the earlier verified release-candidate source.
- Existing clean unsigned Release AAB run `34835983641`: PASS on the earlier verified release-candidate source.
- Critical GDScript compile gate: PASS on corrected intermediate source `5352fe2571e8b5a85140c3b8026ea4799202fdbc`.
- Main-scene boot gate: PASS on the current hardening chain before the latest gameplay-gate commits.
- Catalog behavior gate: PASS on the current hardening chain before the latest gameplay-gate commits.
- Audio feedback smoke gate: PASS on the current hardening chain before the latest gameplay-gate commits.
- New end-to-end gameplay gate: COMMITTED; current-head CI result pending.
- Physical Android QA: NOT VERIFIED in this environment.
- Production signing: OWNER ACTION.
- Google Play Console release: OWNER ACTION.

## Do not
- Do not add backend/network dependencies to the MVP.
- Do not add ads, subscriptions or IAP unless the product decision is explicitly changed.
- Do not claim physical Android or Play verification without direct evidence.
- Do not reset or recreate the project.

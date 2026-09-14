# RULEBREAK — CURRENT TASK

## Current phase
ENGINEERING / MVP BUILD — release candidate hardening

## Current task
Finish the local commercial-readiness pass without expanding the MVP scope.

## Completed in the current hardening pass — 2026-09-14
- Re-audited the current repository state.
- Re-ran the repository-only static integrity gate successfully.
- Removed obsolete duplicate `scripts/core/challenge_view.gd`; `challenge_view_v2.gd` is canonical.
- Hardened `Progression` persistence with durable previous-save backup rotation.
- Added safe temporary backup rotation so a failed replacement can restore the previous primary save.
- Added strict typed payload validation for persisted progression state.
- Added regression coverage for corrupted/truncated/typed-invalid progression payloads.
- Extended the static integrity gate to enforce the canonical renderer and persistence recovery contract.
- Integrated lightweight procedural answer audio feedback and bounded its generator buffer writes.
- Added `tests/test_ui_contract.gd` as a deterministic contract gate for the canonical renderer, four-choice input, logical answer locking, haptics, audio feedback and portrait viewport configuration.
- Added `.github/workflows/ui-contract.yml` so the UI/feedback contract is checked automatically on `main` and pull requests.

## Next safe work
1. Verify the new UI contract workflow and keep automated semantic checks only where they materially improve confidence without expanding MVP scope.
2. Finish production-quality UI/visual polish and audio/haptic feedback where feasible without external device access.
3. Perform physical-device testing: touch, portrait layout, persistence/restart, haptics and all 100 levels.
4. Prepare production signing and complete the Google Play readiness audit.
5. Capture final store assets and run the signed AAB through an owner-side Play testing track.

## Verification truth
- Repository-only static verification: PASS on the latest verified source before the new UI contract commits.
- Existing clean Android verification run `34835983629`: PASS.
- Existing clean unsigned Release AAB run `34835983641`: PASS.
- New UI contract gate: COMMITTED; workflow result not yet observed in this session.
- Godot 4.3 runtime in this local environment: NOT RUN because the executable is unavailable.
- Physical Android QA: NOT VERIFIED in this environment.
- Production signing: OWNER ACTION.
- Google Play Console release: OWNER ACTION.

## Do not
- Do not add backend/network dependencies to the MVP.
- Do not add ads, subscriptions or IAP unless the product decision is explicitly changed.
- Do not claim physical Android or Play verification without direct evidence.
- Do not reset or recreate the project.

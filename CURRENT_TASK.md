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
- Polished the gameplay UI hierarchy with a dedicated rule panel, depth/shadow treatment for answer controls, stronger text hierarchy and clearer mobile touch-state styling.
- Added animated answer feedback so correct/wrong responses have immediate visual acknowledgement alongside existing haptic/audio feedback.
- Extended the UI contract gate to cover the new rule-panel, button-depth and feedback-animation contracts.

## Next safe work
1. Verify the new UI contract workflow and keep automated semantic checks only where they materially improve confidence without expanding MVP scope.
2. Continue production-quality visual/audio/haptic polish only where it can be validated without external device access.
3. Perform physical-device testing: touch, portrait layout, persistence/restart, haptics and all 100 levels.
4. Prepare production signing and complete the Google Play readiness audit.
5. Capture final store assets and run the signed AAB through an owner-side Play testing track.

## Verification truth
- Repository-only source changes: committed through `2403081c51095491bc167cbed00f95800ef19328`.
- Existing clean Android verification run `34835983629`: PASS.
- Existing clean unsigned Release AAB run `34835983641`: PASS.
- New UI contract gate: COMMITTED and extended; workflow result for the latest push is not yet observed in this session.
- Latest gameplay UI polish commit: `f22b06c64ae97469bf70563d30ba59fe70ae8789`.
- Godot 4.3 runtime in this local environment: NOT RUN because the executable is unavailable.
- Physical Android QA: NOT VERIFIED in this environment.
- Production signing: OWNER ACTION.
- Google Play Console release: OWNER ACTION.

## Do not
- Do not add backend/network dependencies to the MVP.
- Do not add ads, subscriptions or IAP unless the product decision is explicitly changed.
- Do not claim physical Android or Play verification without direct evidence.
- Do not reset or recreate the project.

# RULEBREAK — CURRENT TASK

## Current phase
ENGINEERING / MVP BUILD — release candidate hardening

## Current task
Finish the local commercial-readiness pass without expanding the MVP scope.

## Working rule
Work from the current repository state. Do not restart or recreate the project.
Prefer implementation and verification over planning.

## Completed in the current local hardening pass — 2026-09-14
- Re-audited the owner-provided repository ZIP.
- Re-ran repository-only static integrity checks successfully.
- Removed obsolete duplicate `scripts/core/challenge_view.gd`; `challenge_view_v2.gd` is canonical.
- Hardened `Progression` persistence with durable previous-save backup rotation.
- Added safe temporary backup rotation so a failed replacement can restore the previous primary save.
- Added strict typed payload validation for persisted progression state.
- Added regression coverage for corrupted/truncated/typed-invalid progression payloads.
- Extended the static integrity gate to enforce the canonical renderer and persistence recovery contract.
- Updated project state and local build status documentation.

## Next safe work
1. Continue automated semantic checks only where they materially improve confidence without expanding MVP scope.
2. Finish production-quality UI/visual polish and audio/haptic feedback where feasible without external device access.
3. Perform physical-device testing: touch, portrait layout, persistence/restart, haptics and all 100 levels.
4. Prepare production signing and complete the Google Play readiness audit.
5. Capture final store assets and run the signed AAB through an owner-side Play testing track.

## Verification truth
- Repository-only static verification: PASS locally.
- Godot 4.3 runtime in this local environment: NOT RUN because the executable is unavailable.
- Physical Android QA: NOT VERIFIED in this environment.
- Production signing: OWNER ACTION.
- Google Play Console release: OWNER ACTION.

## Do not
- Do not add backend/network dependencies to the MVP.
- Do not add ads, subscriptions or IAP unless the product decision is explicitly changed.
- Do not claim physical Android or Play verification without direct evidence.
- Do not push or modify GitHub unless the owner explicitly requests synchronization.

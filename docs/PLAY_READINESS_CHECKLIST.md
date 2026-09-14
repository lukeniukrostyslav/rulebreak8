# RULEBREAK — Google Play Readiness Checklist

This document separates repository-verifiable release work from owner-side Google Play Console work.

## Repository / build gates

- [x] Android package ID is `com.rulebreak.game`.
- [x] App name is `RULEBREAK`.
- [x] Godot 4.3 project is pinned in repository configuration.
- [x] Portrait viewport is 1080×1920 with canvas-item stretching.
- [x] Android minimum SDK is 24.
- [x] Android target SDK is 36.
- [x] Release architecture is arm64-v8a only.
- [x] Android Debug APK export is verified by CI.
- [x] Android Release AAB export is verified by CI.
- [x] Release AAB is intentionally unsigned in GitHub CI.
- [x] No production keystore or signing secret is committed.
- [x] MVP is offline-first and does not require a backend, account, ads, subscriptions or IAP.

## Gameplay quality gates

- [x] 100 challenge entries exist in the catalog.
- [x] All six challenge families are represented.
- [x] ChallengeManager and ChallengeViewV2 support contracts are covered by automated tests.
- [x] Progression persistence and invariants are covered by automated tests.
- [x] Localization loading/fallback is covered by automated tests.
- [x] Duplicate rapid-answer protection is implemented in the gameplay controller.
- [ ] Physical Android touch QA completed.
- [ ] Portrait layout verified on representative physical Android devices.
- [ ] All 100 levels visually and semantically reviewed on device.
- [ ] Restart/persistence verified on physical Android.
- [ ] Haptic behavior verified on physical Android.
- [ ] Final audio/feedback pass completed.
- [ ] Final visual polish pass completed.

## Store / owner-side gates

These cannot be completed or truthfully marked ready from repository-only access:

- [ ] Production Android App Bundle signing configured with the owner's release keystore.
- [ ] Google Play Console app created and package identity reserved.
- [ ] Store listing title, short description and full description finalized.
- [ ] Store icon and required promotional graphics finalized.
- [ ] Phone screenshots captured from the final signed build.
- [ ] Feature graphic prepared if required by the selected Play listing flow.
- [ ] Content rating questionnaire completed.
- [ ] Data Safety form completed. Current product design intends no collection of personal data, but the final form must match the shipped build and any future SDKs.
- [ ] App category and target audience declarations completed.
- [ ] Privacy policy decision completed with owner/legal review as applicable.
- [ ] Internal/closed testing track completed with the signed AAB.
- [ ] Production rollout decision completed.

## Release evidence

The authoritative technical evidence is the GitHub Actions result for the exact release candidate commit. CI must be GREEN before a commit is described as a verified release candidate.

The unsigned AAB is a structural verification artifact only. It must never be treated as a production-ready upload.

## Current status

Repository engineering is ahead of store readiness. The remaining hard blockers are physical Android QA, final polish, production signing, and owner-side Google Play Console work.

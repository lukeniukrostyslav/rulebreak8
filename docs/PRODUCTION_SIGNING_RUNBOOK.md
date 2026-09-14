# RULEBREAK — PRODUCTION SIGNING RUNBOOK

## Purpose

This document defines the owner-side steps required to turn the CI-verified unsigned Release AAB into a Google Play eligible signed artifact. No signing secret is stored in this repository.

## Security boundary

- Never commit a keystore, private key, service-account key, or signing password.
- Keep the production keystore in a durable encrypted backup under the owner's control.
- Treat loss of the upload/signing credentials as a release incident.
- CI debug signing is not production signing.
- An unsigned AAB is not Play-upload-ready.

## Required owner inputs

Before production release, the owner must have:

1. A Google Play Console developer account.
2. The final application package ID: `com.rulebreak.game`.
3. A production signing strategy compatible with Google Play App Signing.
4. A secure keystore and its passwords, or the Play Console-managed signing path selected during app setup.
5. A verified current-head CI release artifact.

## Release sequence

1. Freeze the source SHA intended for release.
2. Confirm the current SHA has GREEN evidence for the authoritative CI release gate.
3. Build the Release AAB from that exact SHA using the release preset.
4. Sign according to the selected Play App Signing/upload-key setup.
5. Record the signed AAB SHA-256 and source SHA in the release evidence record.
6. Upload to an internal/closed Play testing track first.
7. Install from Play on representative Android devices and verify startup, touch, portrait layout, persistence, haptics, audio, localization and the complete catalog.
8. Only after successful testing consider production rollout.

## Local export reference

The repository contains `Android Release AAB (Unsigned)` as the release-format export preset. The CI pipeline intentionally produces an unsigned AAB and records its source SHA, checksum and metadata. Production credentials are intentionally absent.

## Final verification checklist

- [ ] Source SHA frozen and recorded.
- [ ] Critical compile GREEN.
- [ ] Static integrity GREEN.
- [ ] Catalog behavior GREEN.
- [ ] Localization fallback GREEN.
- [ ] Audio smoke GREEN.
- [ ] Main-scene boot GREEN.
- [ ] End-to-end gameplay GREEN.
- [ ] Debug APK export GREEN.
- [ ] Unsigned Release AAB export GREEN.
- [ ] Production signing completed outside the repository.
- [ ] Signed AAB checksum recorded.
- [ ] Play App Signing/upload-key configuration verified.
- [ ] Closed/internal Play testing completed.
- [ ] Physical Android QA completed.
- [ ] Store listing/data-safety/content-rating declarations reviewed against the exact build.

## Explicit non-claim

Until the owner completes signing and Play testing, the project must not be described as production-ready for Google Play solely because CI generated an unsigned AAB.

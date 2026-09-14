# RULEBREAK — CURRENT RELEASE BLOCKERS

This file is intentionally conservative. Items are blockers until directly evidenced.

## CI / artifacts
- [ ] Fresh authoritative GREEN Android verification on the current release SHA.
- [ ] Fresh authoritative GREEN unsigned Release AAB verification on the current release SHA.
- [ ] Exact artifact SHA-256 recorded for the release candidate.

## Physical device
- [ ] Signed release build installed on a physical Android device.
- [ ] Core gameplay smoke passed on device.
- [ ] Touch / portrait / feedback checks passed.
- [ ] Restart and progression persistence passed.

## Production
- [ ] Production signing configured securely outside source control.
- [ ] Signed AAB verified.
- [ ] Play testing track verified.
- [ ] Store listing and policy declarations completed.

## Non-blocking development evidence
Existing debug APK releases are useful development evidence, but they do not clear production blockers.

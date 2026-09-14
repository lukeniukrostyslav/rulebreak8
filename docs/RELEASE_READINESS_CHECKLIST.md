# RULEBREAK — RELEASE READINESS CHECKLIST

This checklist separates repository/CI evidence from owner-side verification.

## Repository / CI
- [x] Canonical main scene points to the V2 renderer path.
- [x] Critical GDScript compile gate exists.
- [x] Static integrity gate exists.
- [x] All 100 catalog entries have public-contract behavior coverage.
- [x] Localization fallback coverage exists for all catalog entries.
- [x] Audio smoke coverage exists.
- [x] End-to-end gameplay smoke coverage exists.
- [x] Android Debug APK export pipeline exists.
- [x] Unsigned Release AAB export pipeline exists.
- [x] Progression backup/recovery regression coverage exists.
- [ ] Current hardening head has a fresh authoritative GREEN Android verification run.
- [ ] Current hardening head has a fresh authoritative GREEN AAB verification run.

## Owner-side physical Android QA
- [ ] Install signed release build on a physical Android device.
- [ ] Verify portrait layout and touch targets.
- [ ] Verify correct/wrong visual feedback.
- [ ] Verify audio feedback on supported device.
- [ ] Verify haptics on supported device.
- [ ] Verify progression after app restart.
- [ ] Verify save recovery behavior.
- [ ] Exercise all 100 catalog entries.

## Production release
- [ ] Configure production signing outside the repository.
- [ ] Produce signed Release AAB.
- [ ] Verify package/version metadata.
- [ ] Upload signed AAB to a Play testing track.
- [ ] Complete Play Console listing and policy declarations.
- [ ] Capture final store screenshots/assets.
- [ ] Complete owner-side release approval.

## Truth rule
A checked CI item means repository automation has evidence. It does not replace physical-device or Play Console verification. Do not mark owner-side items complete without direct evidence.

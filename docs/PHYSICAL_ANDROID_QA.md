# RULEBREAK — PHYSICAL ANDROID QA

Owner-side checklist for the first real-device pass after CI release-candidate verification.

## Functional pass
1. Install the signed Release AAB through a Play testing track or equivalent owner-controlled distribution.
2. Launch from a clean install.
3. Complete several SEE, REMEMBER, REACT, SWITCH, TRICK and MIX challenges.
4. Verify correct answers advance progression and wrong answers do not advance the level.
5. Close and relaunch the app; verify progression survives restart.
6. Exercise malformed/recovery persistence scenarios only through a controlled test copy of app data.

## Interaction pass
- [ ] Portrait orientation is stable.
- [ ] Four answer controls are comfortably tappable.
- [ ] Rapid second tap cannot submit another answer.
- [ ] Correct feedback is visually distinct.
- [ ] Wrong feedback is visually distinct.
- [ ] Haptic feedback works where device settings permit it.
- [ ] Audio feedback works where device settings permit it.
- [ ] Timed challenges reject premature input and accept input after readiness.

## Content pass
- [ ] All six challenge families are exercised.
- [ ] No raw `RULE_*` key is visible to the player.
- [ ] Extended challenges show English fallback when a localized description is absent.
- [ ] No progression regression is observed across the 100-level catalog.

## Persistence pass
- [ ] Progression survives app close and relaunch.
- [ ] A normal save can be restored after restart.
- [ ] No duplicate or lost progress is observed during repeated restart testing.
- [ ] Recovery behavior is acceptable if a controlled persistence corruption test is performed.

## Evidence
Record device model, Android version, build/version code, install method, date, and any failure reproduction steps. Attach screenshots/video for every release-blocking defect.

## Exit criteria
Physical QA is complete only when all release-blocking checks pass on at least one representative Android device and the signed build used for testing is identified.

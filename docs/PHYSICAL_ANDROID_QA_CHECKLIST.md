# RULEBREAK — PHYSICAL ANDROID QA CHECKLIST

CI validates the repository and headless/export pipeline. This checklist covers the remaining device-only evidence.

## Test matrix

Use at least one current Android phone representative of the intended Play audience. If possible, repeat on a second device with a different screen size/API level.

## Install and launch

- [ ] Install the APK without errors.
- [ ] App launches directly into the intended main scene.
- [ ] No unexpected permission prompts appear.
- [ ] Cold launch is stable after force-stop.
- [ ] Relaunch after reboot is stable.

## Touch and layout

- [ ] Every answer control is comfortably tappable with a thumb.
- [ ] Rapid double-tap cannot submit two answers.
- [ ] Buttons visibly acknowledge press/correct/wrong state.
- [ ] Rule text remains readable at normal Android font/display settings.
- [ ] No clipping, overlap or off-screen controls in portrait.
- [ ] System gesture/navigation areas do not obstruct controls.
- [ ] Rotation behavior matches the portrait-first product decision.

## Gameplay

- [ ] Rule is understandable before the first answer.
- [ ] Correct answer advances exactly once.
- [ ] Wrong answer does not incorrectly advance.
- [ ] Timed challenge expires correctly when the response window closes.
- [ ] Timeout feedback is distinguishable from ordinary wrong-answer feedback.
- [ ] Visual, haptic and audio feedback do not block the next challenge.
- [ ] Play through all 100 catalog entries, recording any rendering or semantic anomaly.

## Persistence

- [ ] Progress survives app restart.
- [ ] Progress survives force-stop/relaunch.
- [ ] A later level is not unexpectedly reset to the beginning.
- [ ] Corruption-recovery behavior is covered by automated tests; do not intentionally damage user data on a production device unless a separate test profile is used.

## Audio and haptics

- [ ] Correct answer feedback is audible where device volume allows.
- [ ] Wrong answer feedback is audible and distinct.
- [ ] Timeout feedback is distinct.
- [ ] Haptic feedback occurs without excessive vibration.
- [ ] Silent/vibrate device behavior remains acceptable.

## Localization

- [ ] English fallback never exposes raw `RULE_*` keys during normal play.
- [ ] At least the intended launch languages are spot-checked on-device.
- [ ] Text expansion does not break the portrait layout.

## Release smoke

- [ ] No crash during a representative uninterrupted session.
- [ ] No ANR during rapid answering.
- [ ] No network connection is required for normal gameplay.
- [ ] App remains functional in airplane mode.
- [ ] Final tested build's SHA-256 is recorded.
- [ ] Final tested build source SHA is recorded.

## Evidence rule

Mark a checkbox only after direct device observation. CI success does not substitute for physical-device evidence. Any failure becomes a release-blocking defect until triaged and retested.

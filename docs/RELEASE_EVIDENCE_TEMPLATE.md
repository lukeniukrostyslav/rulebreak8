# RULEBREAK — RELEASE EVIDENCE RECORD

Copy this template for each release candidate.

## Identity
- Source SHA:
- Version name:
- Version code:
- Artifact type: Debug APK / Unsigned Release AAB / Signed Release AAB
- Build timestamp:
- SHA-256:

## CI evidence
- Critical GDScript compile: PASS / FAIL
- Static integrity: PASS / FAIL
- Catalog behavior: PASS / FAIL
- Localization fallback: PASS / FAIL
- Audio smoke: PASS / FAIL
- Main scene boot: PASS / FAIL
- End-to-end gameplay: PASS / FAIL
- Android export: PASS / FAIL

## Device evidence
- Device model:
- Android version:
- Install method:
- Physical QA result: PASS / FAIL / NOT RUN
- Screenshots/video attached: YES / NO

## Release decision
- Production signing: COMPLETE / NOT COMPLETE
- Play testing track: COMPLETE / NOT COMPLETE
- GO / NO-GO:
- Blocking defects:

## Rule
Do not mark a field PASS without evidence tied to the exact source SHA or exact signed artifact.

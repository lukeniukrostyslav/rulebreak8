# RULEBREAK — RELEASE ARTIFACT POLICY

## Artifact classes

### Debug APK
A development artifact for smoke installation and debugging. It must identify the exact source SHA and must never be described as a production release.

### Unsigned Release AAB
A release-format artifact used to validate the Android export pipeline before production credentials are introduced. It is not upload-ready for Google Play until signed.

### Signed Release AAB
The only artifact eligible for Play testing/production distribution. It must be produced from an authoritative GREEN source SHA and its checksum must be recorded.

## Evidence requirements
Every published artifact record must contain:
- source commit SHA;
- artifact type;
- version name/code;
- build timestamp;
- SHA-256 digest where available;
- verification status;
- explicit statement of whether the artifact is signed.

## Integrity rule
Do not compare artifacts only by version label. The source SHA and SHA-256 digest are the authoritative identity fields.

## Release rule
A debug APK or unsigned AAB may demonstrate engineering progress, but neither is evidence of Play production readiness.

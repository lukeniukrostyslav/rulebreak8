# RULEBREAK — PRODUCTION SIGNING BOUNDARY

Production signing is intentionally kept outside the repository.

## Required owner inputs
- Android keystore.
- Keystore password.
- Key alias and key password.
- Final package/application ID.
- Release version name and version code.

## Rules
- Never commit keystore files, signing passwords, or Play service-account credentials.
- Use GitHub Actions secrets or the owner's secure local release environment for signing.
- Keep unsigned AAB verification as a separate pre-signing gate.
- Record the SHA-256 of the final signed artifact in the release record.
- Test the exact signed artifact that is uploaded to Google Play.

## Release sequence
1. Start from a fresh authoritative GREEN CI source SHA.
2. Build the unsigned Release AAB.
3. Sign outside the repository using protected credentials.
4. Verify the signed artifact metadata and checksum.
5. Upload the exact signed AAB to a Play testing track.
6. Perform owner-side device verification.
7. Only then approve production rollout.

This document is a release boundary, not evidence that production signing has already been completed.

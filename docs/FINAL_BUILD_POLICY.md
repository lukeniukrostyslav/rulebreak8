# RULEBREAK Final Build Policy

This project intentionally separates continuous product verification from release artifact creation.

## Required order

1. Close all gameplay/content/UX/data/persistence/localization/audio/haptics/security/offline blocks.
2. Close all automated compile, runtime, family-behavior, catalog, localization, save/recovery and release-contract checks.
3. Perform a final source audit and freeze the release SHA.
4. Only then create the final APK for physical Android QA.
5. If physical QA finds a defect, return to development and repeat the relevant automated gates before creating another APK.
6. After physical QA passes, perform production signing and create the final AAB.
7. Only after signed AAB verification proceed to Google Play Console testing/release.

## Artifact rule

Routine development work must not treat an intermediate APK/AAB as a product milestone. APK/AAB artifacts are release-gate outputs, not a substitute for completing the underlying product blocks.

## Status rule

A block is not considered complete merely because source code exists. It must have the appropriate implementation and verification evidence. Physical Android QA, production signing and Google Play remain separate gates and cannot be marked complete by headless CI alone.

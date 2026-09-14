# RULEBREAK — Android APK release path

## Purpose

The repository now treats the Android Debug APK as a first-class installable engineering artifact. A push to `main` runs the Godot verification workflow, exports the APK, records its SHA-256 checksum, uploads the artifact, and publishes the APK plus checksum to a GitHub Release.

## What the automated release proves

The workflow must pass, on the same commit SHA, before the APK is published:

- repository/static integrity checks;
- release-contract checks;
- critical GDScript compilation under Godot 4.3;
- headless challenge-manager, renderer, localization, fallback, audio and progression tests;
- end-to-end headless gameplay-loop smoke test;
- translation generation and import-cache reset;
- Android Debug APK export;
- APK ZIP integrity and arm64 native library presence;
- SHA-256 checksum generation.

The published debug APK is a development/QA build. It is not the production-signed Google Play artifact.

## GitHub Release naming

The automation uses:

`v0.1.0-debug.<GitHub run number>`

Each release note records the exact source commit SHA. The checksum file is published beside the APK.

## Production boundary

A production Google Play release still requires owner-side work that cannot be fabricated by CI:

1. create/protect the production signing key and keep it outside the repository;
2. configure the signed Release AAB export using the production credentials;
3. install and exercise the signed build on physical Android hardware;
4. complete Play Console app-content, Data Safety, content rating and store-asset checks;
5. upload the signed AAB to a Play testing track and validate the delivered build;
6. promote only after the external QA evidence is acceptable.

Do not relabel the debug APK as a production release and do not commit signing secrets.

## Artifact traceability

For every candidate APK, record:

- Git commit SHA;
- GitHub Actions run number;
- APK filename;
- SHA-256 checksum;
- Android package name;
- version name/code;
- whether the artifact is debug or production-signed.

This keeps the installable APK reproducible and prevents an older artifact from being mistaken for the current source.

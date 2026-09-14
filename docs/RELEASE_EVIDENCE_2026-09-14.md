# RULEBREAK — RELEASE EVIDENCE — 2026-09-14

## Current source
- Repository: `lukeniukrostyslav/rulebreak8`
- Release-candidate branch: `main`
- Current evidence baseline commit: `d77870dac9061820744805e0c23452c94f965d4c`

## Confirmed GitHub evidence
- UI contract workflow run `34871385247` passed on source `a8b13483bcd4e894e13155486957d890128e6d74`.
- The UI contract job completed all configured steps, including Godot 4.3 installation, contract checks, Godot contract execution and generated-artifact verification.
- Main-scene boot run `34881457951` passed on source `1267a2d6076f55627ec2ed102fc80defcaec3042`.
- Manager contract run `34881457969` passed on source `1267a2d6076f55627ec2ed102fc80defcaec3042`.

## Historical engineering evidence
- Clean Android verification run `34835983629` passed on its then-current source SHA.
- Clean unsigned Release AAB verification run `34835983641` passed on its then-current source SHA.
- Debug APK release `v0.1.0-debug.221` contains a real 69 MB APK with SHA-256 `f7d6cd7b216ddd594e392eaffef525cbc63c96ca7275b8b2587b5dfae2154240`, but it was built from older source `ccc88777a84e349142bf31784ed9c08ed267605a`.
- Historical runs and artifacts do not certify later source commits.

## Current release gate
The current release gate is pending until the required Android Debug/APK and unsigned AAB verification workflows complete successfully on the same current source SHA `d77870dac9061820744805e0c23452c94f965d4c`. The latest workflow runs were queued after the artifact-evidence hardening pass; no current-head GREEN claim is made before completion. See `docs/CI_RELEASE_GATE.md`.

## Explicit external gates
- Physical Android QA: NOT VERIFIED here.
- Production signing: NOT VERIFIED here.
- Signed Release AAB: NOT VERIFIED here.
- Google Play testing/production: NOT VERIFIED here.

## Evidence rule
Never promote historical green runs to current-release evidence. Every release claim must identify the exact source SHA tested.

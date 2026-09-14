# RULEBREAK — RELEASE EVIDENCE — 2026-09-14

## Current source
- Repository: `lukeniukrostyslav/rulebreak8`
- Release-candidate branch: `main`
- Evidence baseline commit before this record: `ac19055c766c0aa9e9695780f7731526949d596e`

## Confirmed GitHub evidence
- UI contract workflow run `34871385247` passed on source `a8b13483bcd4e894e13155486957d890128e6d74`.
- The UI contract job completed all configured steps, including Godot 4.3 installation, contract checks, Godot contract execution and generated-artifact verification.

## Historical engineering evidence
- Clean Android verification run `34835983629` passed on its then-current source SHA.
- Clean unsigned Release AAB verification run `34835983641` passed on its then-current source SHA.
- These historical runs do not certify later source commits.

## Current release gate
The current release gate remains pending until the required Android Debug/APK and unsigned AAB verification workflows complete successfully on the same current source SHA. See `docs/CI_RELEASE_GATE.md`.

## Explicit external gates
- Physical Android QA: NOT VERIFIED here.
- Production signing: NOT VERIFIED here.
- Signed Release AAB: NOT VERIFIED here.
- Google Play testing/production: NOT VERIFIED here.

## Evidence rule
Never promote historical green runs to current-release evidence. Every release claim must identify the exact source SHA tested.

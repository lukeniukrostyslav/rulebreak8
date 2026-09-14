# RULEBREAK QA Gates

This document records the deterministic GitHub-side gates added during release-candidate hardening.

## Main scene boot

`tests/test_main_scene_boot.gd` loads and instantiates `main.tscn` under Godot 4.3 headlessly. This catches parser/preload/scene-instantiation failures that isolated unit tests can miss.

Workflow: `RULEBREAK main scene boot`.

## Catalog behavior

`tests/test_challenge_catalog_behavior.gd` iterates through all 100 catalog entries and verifies:

- exactly four choices are present;
- the declared correct index is in range;
- the declared correct choice is accepted by `ChallengeManager.check()`;
- every other choice is rejected.

Workflow: `RULEBREAK catalog behavior`.

## Android release verification

The existing Android verification workflow remains the release-candidate gate for repository integrity, headless runtime tests, translations, Debug APK export, and release artifact publication. The AAB workflow separately validates the unsigned Release AAB export.

The unsigned AAB is an engineering artifact only. Production signing, physical-device QA, and Google Play submission remain explicit external release gates.

## Rule

A green isolated gate never overrides a failed higher-level gate. The current source SHA must be verified when interpreting any CI result; failures from older SHAs are not treated as failures of the current source, and a current source is not considered release-ready until its required gates pass.

# RULEBREAK — Build & Test Gate

## Deterministic smoke test

The repository now contains `tests/test_challenge_manager.gd`.

Run it with a Godot editor binary from the project root:

```bash
godot --headless --path . --script tests/test_challenge_manager.gd
```

Expected output:

```text
RULEBREAK ChallengeManager tests: PASS
```

This test checks the 20-challenge catalog, unique IDs, four-choice shape, valid correct indexes, all six challenge families, answer checking, reset behavior and full catalog wraparound.

A passing smoke test is not a substitute for runtime gameplay QA.

## Development gate

1. Open project in Godot 4.x.
2. Run the main scene.
3. Verify the rule is visible before input.
4. Verify correct input increments streak and advances.
5. Verify wrong input resets streak.
6. Restart the app and verify local progression is restored.
7. Test touch input on a physical Android device.
8. Check portrait layout at multiple phone resolutions.
9. Run the deterministic ChallengeManager smoke test.
10. Verify every challenge visually and semantically, including timing-dependent challenges.

## Release gate

- No debug-only behavior.
- No secrets committed.
- No backend dependency.
- No ad/IAP/subscription SDK in MVP.
- Release signing configured outside the repository.
- Google Play build is AAB, not APK.

Godot supports headless command-line export/testing workflows; an export preset must exist before `--export-release` can produce a build. citeturn0search0turn0search1

For Google Play, the Android build must be an AAB and signed with a non-debug keystore. Keep the keystore and passwords outside GitHub. citeturn0search3

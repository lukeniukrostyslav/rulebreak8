# RULEBREAK — Build & Test Gate

## Development gate

1. Open project in Godot 4.x.
2. Run the main scene.
3. Verify the rule is visible before input.
4. Verify correct input increments streak and advances.
5. Verify wrong input resets streak.
6. Restart the app and verify local progression is restored.
7. Test touch input on a physical Android device.
8. Check portrait layout at multiple phone resolutions.

## Release gate

- No debug-only behavior.
- No secrets committed.
- No backend dependency.
- No ad/IAP/subscription SDK in MVP.
- Release signing configured outside the repository.
- Google Play build is AAB, not APK.

Godot's current Android documentation confirms that Google Play distribution requires an Android App Bundle and release signing with a non-debug key. Keep the signing key and passwords outside GitHub.

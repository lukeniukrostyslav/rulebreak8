# RULEBREAK — Architecture

## Runtime flow

`Game` → `ChallengeManager` → `ChallengeDefinition` → player input → result → `Progression` → next challenge.

## Rules

1. Gameplay logic must not depend on online services.
2. Challenge definitions are data-driven where practical.
3. Progress is local-only in MVP.
4. No ads, IAP, subscriptions, analytics SDKs or backend in MVP.
5. A failed challenge must explain the rule/result clearly enough that retry feels fair.
6. UI may present a rule, but the challenge manager remains the source of truth for correctness.

## Planned modules

- `scripts/core/challenge_manager.gd`
- `scripts/core/progression.gd`
- `scripts/data/challenges.json`
- `scripts/game.gd`

## Android

Development can use APK for device testing. Google Play release uses Android App Bundle (AAB) and a non-debug signing key. See official Godot Android export documentation before release configuration.

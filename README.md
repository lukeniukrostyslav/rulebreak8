# RULEBREAK

**The game that teaches you the rule — then makes you break it.**

Android-first premium micro-puzzle game. MVP target: one-time purchase around €1.99, no ads, no subscriptions, no IAP, no backend, no required internet.

## Current MVP state

- Godot 4.3 project configuration
- Portrait 1080×1920 mobile-first viewport
- Live ChallengeManager + Progression game loop
- Exactly 100 challenge catalog entries across six families with family-specific visual/timing implementations
- ChallengeView V2 is the canonical renderer for SEE / REMEMBER / REACT / SWITCH / TRICK / MIX
- Streak, best streak and local progression/statistics persistence with backup recovery
- 21-locale localization infrastructure with English fallback for extended challenge rules
- Deterministic catalog, renderer, localization, progression, audio and main-scene runtime gates
- Android Debug APK and unsigned Release AAB verification pipelines
- Release-candidate QA and build documentation in `docs/BUILD_AND_TEST.md` and `docs/QA_GATES.md`

## Product direction

Short 5–30 second challenges. The player learns a simple rule, then must notice when the rule changes or when the obvious interpretation is wrong.

The engineering catalog contains 100 entries. The current 20 seed challenges are complemented by 80 extended entries built from reusable family-specific gameplay templates; the catalog is not falsely presented as 100 bespoke scenes.

Future product ideas such as ENDLESS/STREAK, DAILY RULE and Challenge Friend are outside the current MVP release scope until explicitly promoted.

## Architecture

Rule Engine → Challenge Manager → Challenge Modules → Progression → UI → Local Save.

Challenge families: SEE, REMEMBER, REACT, SWITCH, TRICK, MIX.

## Commercial target

Google Play premium Android game. Initial target price around €1.99. No recurring monetization in MVP.

## Verification status

GitHub Actions is the authoritative runtime/build verification layer for the current engineering environment.

- Repository integrity: verified by automated gates
- Critical GDScript compilation: verified under Godot 4.3
- Main-scene boot: verified headlessly
- 100-level catalog behavior: verified through the public `ChallengeManager` contract
- Renderer support: verified for all 100 catalog entries
- Localization fallback coverage: verified for all 100 entries
- Audio feedback generator/player path: verified under Godot's Dummy audio driver
- Android Debug APK export: verified by CI
- Android Release AAB export: verified by CI as an unsigned engineering artifact
- Production signing: not configured by design
- Physical Android device QA: not performed in this environment
- Google Play Console submission/testing: not performed

> CI verification is not a substitute for physical-device QA, production signing, or Play Console validation. Release readiness must only be claimed after those external gates are completed.

See `PROJECT_STATE.md` for the detailed project state, progress estimates and current blockers.

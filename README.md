# RULEBREAK

**The game that teaches you the rule — then makes you break it.**

Android-first premium micro-puzzle game. MVP target: one-time purchase around €1.99, no ads, no subscriptions, no IAP, no backend, no required internet.

## Current MVP state

- Godot 4.3 project configuration
- Portrait 1080×1920 mobile-first viewport
- Live ChallengeManager + Progression game loop
- 100 challenge catalog entries across six families with family-specific visual/timing implementations
- ChallengeView implementations for SEE / REMEMBER / REACT / SWITCH / TRICK / MIX
- Streak, best streak and local statistics persistence
- 21-locale localization infrastructure with English fallback for extended challenge rules
- Deterministic ChallengeManager and ChallengeView tests
- Build/test and release-gate documentation in `docs/BUILD_AND_TEST.md`

## Product direction

Short 5–30 second challenges. The player learns a simple rule, then must notice when the rule changes or when the obvious interpretation is wrong.

Target content: 100 handcrafted challenges, building on the 100-level engineering catalog, then ENDLESS/STREAK, DAILY RULE and Challenge Friend.

## Architecture

Rule Engine → Challenge Manager → Challenge Modules → Progression → UI → Local Save.

Challenge families: SEE, REMEMBER, REACT, SWITCH, TRICK, MIX.

## Commercial target

Google Play premium Android game. Initial target price around €1.99. No recurring monetization in MVP.

## Verification status

- Research / concept / product direction: 100%
- Architecture: 85%
- Engineering: 50% estimate
- Challenge content: 90% estimate
- UX / visual: 78% estimate
- Persistence: 70% estimate; code hardened, runtime restore not verified
- Audio / feedback: 10% estimate
- QA / testing: 15% — deterministic tests strengthened, runtime execution not verified in this environment
- Android build: 10% infrastructure — debug APK workflow and unsigned release-AAB workflow are defined; no build executed in this environment
- Google Play readiness: 0%
- Release: 0%

> Percentages are management estimates, not claims of completed release readiness. Runtime gameplay, Android device testing and Google Play build/signing remain unverified until actually executed.

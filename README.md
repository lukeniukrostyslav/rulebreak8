# RULEBREAK

**The game that teaches you the rule — then makes you break it.**

Android-first premium micro-puzzle game. MVP target: one-time purchase around €1.99, no ads, no subscriptions, no IAP, no backend, no required internet.

## Current MVP state

- Godot 4.3 project configuration
- Portrait 1080×1920 mobile-first viewport
- Live ChallengeManager + Progression game loop
- 20 canonical challenge definitions across six families
- ChallengeView implementations for SEE / REMEMBER / REACT / SWITCH / TRICK / MIX
- Streak, best streak and local statistics persistence
- 21-locale localization infrastructure
- Deterministic ChallengeManager smoke test in `tests/test_challenge_manager.gd`
- Build/test and release-gate documentation in `docs/BUILD_AND_TEST.md`

## Product direction

Short 5–30 second challenges. The player learns a simple rule, then must notice when the rule changes or when the obvious interpretation is wrong.

Target content: 100 handcrafted challenges, expanding from the current 20-challenge engineering catalog into a larger campaign, then ENDLESS/STREAK, DAILY RULE and Challenge Friend.

## Architecture

Rule Engine → Challenge Manager → Challenge Modules → Progression → UI → Local Save.

Challenge families: SEE, REMEMBER, REACT, SWITCH, TRICK, MIX.

## Commercial target

Google Play premium Android game. Initial target price around €1.99. No recurring monetization in MVP.

## Verification status

- Research / concept / product direction: 100%
- Architecture: 85%
- Engineering: 84% estimate
- Challenge content: 78% estimate
- UX / visual: 96% estimate
- Persistence: 60% estimate; code hardened, runtime restore not verified
- Audio / feedback: 5% estimate
- QA / testing: 5% — deterministic test exists, runtime execution not verified in this environment
- Android build: 0% VERIFIED — no export preset/build has been executed here
- Google Play readiness: 0%
- Release: 0%

> Percentages are management estimates, not claims of completed release readiness. Runtime gameplay, Android device testing and Google Play build/signing remain unverified until actually executed.

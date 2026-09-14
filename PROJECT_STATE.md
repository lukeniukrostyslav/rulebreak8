# RULEBREAK — PROJECT STATE

## Purpose
RULEBREAK is an Android-first premium micro-puzzle game for Google Play.

Core promise: **The game that teaches you the rule — then makes you break it.**

## Current objective
Build a polished, offline-first MVP that can be tested on Android and prepared for Google Play.

Commercial target: one-time purchase around €1.99. MVP has no ads, subscriptions, IAP, backend, AI dependency, or required internet connection.

## Current phase
ENGINEERING / MVP BUILD — release candidate hardening

## Current repository state
Repository: `lukeniukrostyslav/rulebreak8`
Default branch: `main`
Latest hardening source is on `main`; GitHub Actions is the authoritative runtime/build verification layer for this environment.
Current foundation: Godot 4.3 configuration, 100-level challenge catalog, canonical V2 runtime renderer, local progression, localization fallbacks, deterministic test gates and Android APK/AAB export pipelines targeting current Play requirements.

## Product rules
- Short challenges, generally 5–30 seconds.
- Player learns a rule, then detects a change, exception, or misleading interpretation.
- Failure must feel understandable rather than arbitrary.
- Minimal UI, large touch targets, fast feedback.
- Offline play is a core MVP requirement.
- Local progression only for MVP.

## Challenge families
SEE / REMEMBER / REACT / SWITCH / TRICK / MIX

## Current challenge catalog
- Exactly 100 entries: 20 seed entries + 80 extended entries.
- Distribution: SEE 18, REMEMBER 20, REACT 18, SWITCH 19, TRICK 19, MIX 6.
- Extended choices are family-aware.
- `ChallengeManager` and `ChallengeViewV2` have an explicit support contract exercised by tests.
- Extended rule descriptions have an English fallback so raw `RULE_*` keys are not intentionally shown.
- Important quality caveat: the 100-entry catalog is not 100 bespoke hand-authored scenes; extended entries use reusable family-specific gameplay templates.

## Architecture target
Rule Engine → Challenge Manager → Challenge Modules → Progression → UI → Local Save.

## Non-goals for MVP
- Online multiplayer
- User accounts
- Cloud backend
- AI runtime dependency
- Ads
- Subscriptions
- IAP
- Complex economy
- Always-online daily service

## Detailed progress (management estimates)
| Major block | Progress |
|---|---:|
| Research / Product concept | 100% |
| Game design / core loop | 100% |
| Visual direction | 78% |
| Architecture | 92% |
| Challenge system | 92% |
| 100-level content catalog | 85% |
| UI / UX | 78% |
| Progression / local save | 78% |
| Localization infrastructure | 88% |
| Audio / haptics / feedback | 18% |
| Automated QA / deterministic tests | 52% |
| Android build pipeline | 82% |
| Android device QA | 0% |
| Monetization model | 90% |
| Production signing | 0% |
| Google Play readiness | 0% |
| Release readiness | 0% |

**Overall: approximately 63%** of the full commercial release target.

Percentages are management estimates against the complete product/release scope. They are not code-coverage measurements and must not be interpreted as runtime verification.

## Verification status
- Local Python static integrity gate passes for 100 unique levels, locked family distribution, 21 locales and Android API 36 configuration.
- `ChallengeViewV2` has explicit local types for the variables that previously caused Godot CI inference failures.
- Local execution environment still does not contain the Godot executable, so Godot runtime tests and Android exports are not falsely marked as passed.
- GitHub Actions now includes the static gate before runtime tests and targets Android API 36 for both APK and unsigned AAB verification.

## Release engineering
- `main.tscn` points directly to the canonical `scripts/game.gd` controller.
- `scripts/game.gd` directly instantiates `ChallengeViewV2`.
- Obsolete `game_bootstrap.gd` and duplicate `extended_localization.gd` were removed.
- Progression persists the current challenge level while remaining compatible with older save files.
- Answer feedback requests short Android haptic feedback.
- Android Debug APK workflow is bounded with job/runtime/export timeouts.
- Unsigned Android Release AAB workflow is present and bounded with runtime/export timeouts.
- Verification workflows use concurrency cancellation to prevent stale runs from accumulating.
- Android release presets pin min SDK 24 / target SDK 36 and arm64 export.
- Production signing is intentionally not embedded in the repository.

## Next safe work
1. Verify the GitHub Actions runtime tests and Android APK/AAB exports after the hardening commits.
2. Fix any runtime/export failures discovered by those gates.
3. Device-test all 100 levels, touch targets, portrait layout and persistence.
4. Finish production-quality audio/haptics/feedback and visual polish.
5. Prepare production signing and complete the Google Play readiness audit.

## Current blockers
- Godot runtime/build verification depends on the GitHub-hosted CI environment from this session.
- Physical Android device testing is not available in this execution environment.
- Production signing/Play Console submission require owner-side release credentials and account access.
- Full audio/visual polish remains incomplete.

## Truth rule
Never claim a feature is implemented unless it exists in the repository and has been checked. If something is only designed or planned, label it PLANNED.

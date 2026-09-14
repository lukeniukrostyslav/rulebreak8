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
| Challenge system | 94% |
| 100-level content catalog | 87% |
| UI / UX | 78% |
| Progression / local save | 80% |
| Localization infrastructure | 92% |
| Audio / haptics / feedback | 20% |
| Automated QA / deterministic tests | 62% |
| Android build pipeline | 95% |
| Android device QA | 0% |
| Monetization model | 90% |
| Production signing | 0% |
| Google Play readiness | 5% |
| Release readiness | 5% |

**Overall: approximately 66%** of the full commercial release target.

Percentages are management estimates against the complete product/release scope. They are not code-coverage measurements and must not be interpreted as runtime/device verification.

## Verification status
- Latest hardening commit `32cadfef545c62cb494bb9a07b9502ab21a2510f` passed the `Godot 4.3 verification` GitHub Actions job.
- The GREEN verification job passed repository integrity, Godot headless ChallengeManager/ChallengeView/localization tests, translation generation, Android Debug APK export, APK integrity checks, artifact upload and GitHub Release publication.
- The same commit passed the independent `Android release artifact verification` job, including repository integrity, runtime gates, translation generation and unsigned Android Release AAB export/integrity checks.
- The CI-produced AAB is unsigned by design; this does not constitute production signing or Google Play readiness.
- Local execution environment still does not contain the Godot executable, so CI remains the authoritative runtime/build verification layer for this session.

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
1. Inspect the newly produced CI APK/AAB artifacts as release evidence.
2. Strengthen any remaining automated catalog/rendering contract checks without expanding MVP scope.
3. Device-test all 100 levels, touch targets, portrait layout and persistence/restart behavior.
4. Finish production-quality audio/haptics/feedback and visual polish.
5. Prepare production signing and complete the Google Play readiness audit.

## Current blockers
- Physical Android device testing is not available in this execution environment.
- Production signing/Play Console submission require owner-side release credentials and account access.
- Full audio/visual polish remains incomplete.

## Truth rule
Never claim a feature is implemented unless it exists in the repository and has been checked. If something is only designed or planned, label it PLANNED.

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
Latest verified hardening source: `397ac07084db3a6bd6c1bef5f233d37d54cf59c3`.
GitHub Actions is the authoritative runtime/build verification layer for this environment.
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
- `ChallengeManager` and `ChallengeViewV2` have an explicit support contract exercised by runtime tests for all 100 catalog entries.
- Seed IDs/families/choice-count/correct-index semantics are statically cross-checked against `scripts/data/challenges.json`.
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
| Concept / positioning | 100% |
| Core gameplay / loop | 100% |
| Visual direction | 78% |
| Architecture | 92% |
| Rule Engine | 92% |
| Challenge Manager | 95% |
| Challenge Modules | 91% |
| 100-level content catalog | 88% |
| SEE | 92% |
| REMEMBER | 90% |
| REACT | 92% |
| SWITCH | 90% |
| TRICK | 85% |
| MIX | 82% |
| UI / UX | 78% |
| Android-first adaptation | 85% |
| Local Save / Progression | 87% |
| Localization | 92% |
| Fallback / language resilience | 95% |
| Audio / haptics / feedback | 20% |
| Static Integrity Tests | 98% |
| Runtime Tests | 90% |
| Automated QA | 90% |
| Android APK pipeline | 98% |
| Android AAB pipeline | 95% |
| Production signing | 0% |
| Physical Android QA | 0% |
| Google Play readiness | 5% |
| Release readiness | 15% |
| Documentation / Project State | 95% |
| Release-candidate hardening | 84% |

**Overall: approximately 70%** of the full commercial release target.

Percentages are management estimates against the complete product/release scope. They are not code-coverage measurements and must not be interpreted as physical-device verification.

## Verification status — 2026-09-14
- Commit `397ac07084db3a6bd6c1bef5f233d37d54cf59c3` passed `Godot 4.3 verification` run `34822314605` GREEN.
- Static integrity passed the 100-level catalog contract, seed/runtime semantic synchronization, family distribution, 21 locale headers and Android API 36/arm64 configuration.
- Headless runtime gates passed ChallengeManager, ChallengeView, localization, extended rule fallback and Progression persistence/invariant tests.
- ChallengeView runtime coverage now verifies renderer support for all 100 catalog entries and explicit extended REACT/SWITCH contracts.
- Android Debug APK export passed, artifact upload passed, and GitHub Release publication passed.
- Debug APK artifact: `rulebreak-android-debug`, 23,860,042 bytes, SHA-256 `d620b0f6fd299215d3945608c8498bae4296f255bc1a18257bf78dce2464eb9d`.
- Independent `Android release artifact verification` run `34822314449` also completed GREEN.
- Unsigned Android Release AAB export, archive validation and artifact upload passed.
- AAB artifact: `rulebreak-android-release-aab`, 40,602,420 bytes, SHA-256 `aa7c8ebb454ddbf2eb10ee26bcdfd8d08d07d5c8468a707bbc941064f590a497`.
- The AAB is unsigned by design; this does not constitute production signing or Google Play readiness.
- Local execution environment still does not contain the Godot executable, so CI remains the authoritative runtime/build verification layer for this session.

## Release engineering
- `main.tscn` points directly to the canonical `scripts/game.gd` controller.
- `scripts/game.gd` directly instantiates `ChallengeViewV2`.
- Obsolete `game_bootstrap.gd` and duplicate `extended_localization.gd` were removed.
- Progression persists the current challenge level while remaining compatible with older save files and enforces streak/current-level invariants.
- Answer feedback requests short Android haptic feedback.
- Android Debug APK workflow is bounded with job/runtime/export timeouts.
- Unsigned Android Release AAB workflow is present and bounded with runtime/export timeouts.
- Verification workflows use concurrency cancellation to prevent stale runs from accumulating.
- Android release presets pin min SDK 24 / target SDK 36 and arm64 export.
- Production signing is intentionally not embedded in the repository.

## Next safe work
1. Inspect/download the verified CI APK/AAB artifacts as release evidence where useful.
2. Continue automated semantic catalog/rendering checks only where they improve confidence without expanding MVP scope.
3. Perform physical-device testing: touch, portrait layout, persistence/restart and all 100 levels.
4. Finish production-quality audio/haptics/feedback and visual polish.
5. Prepare production signing and complete the Google Play readiness audit.

## Current blockers
- Physical Android device testing is not available in this execution environment.
- Production signing/Play Console submission require owner-side release credentials and account access.
- Full audio/visual polish remains incomplete.

## Truth rule
Never claim a feature is implemented unless it exists in the repository and has been checked. If something is only designed or planned, label it PLANNED.

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
Latest verified release-candidate source: `34e218e0f8e4f338e70937029b58529eed8c4578`.
A subsequent repository-cleanup commit `3c33eef2487a13504869abddf1f40241029542e2` removed the temporary GDScript fixer workflow; no gameplay/source files were changed by that cleanup.
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
| Architecture | 94% |
| Rule Engine | 92% |
| Challenge Manager | 97% |
| Challenge Modules | 91% |
| 100-level content catalog | 88% |
| SEE | 92% |
| REMEMBER | 90% |
| REACT | 92% |
| SWITCH | 90% |
| TRICK | 85% |
| MIX | 82% |
| UI / UX | 80% |
| Android-first adaptation | 89% |
| Local Save / Progression | 93% |
| Localization | 92% |
| Fallback / language resilience | 95% |
| Audio / haptics / feedback | 25% |
| Static Integrity Tests | 99% |
| Runtime Tests | 96% |
| Automated QA | 95% |
| Android APK pipeline | 99% |
| Android AAB pipeline | 99% |
| Production signing | 0% |
| Physical Android QA | 0% |
| Google Play readiness | 8% |
| Release readiness | 22% |
| Documentation / Project State | 99% |
| Release-candidate hardening | 94% |

**Overall: approximately 73%** of the full commercial release target.

Percentages are management estimates against the complete product/release scope. They are not code-coverage measurements and must not be interpreted as physical-device verification.

## Verification status — 2026-09-14
- Clean Android verification run `34835983629` on source `34e218e0f8e4f338e70937029b58529eed8c4578` completed GREEN.
- The run passed repository integrity, Godot 4.3 headless runtime tests, translation preparation, Android Debug APK export, APK upload and GitHub Release publication.
- The runtime gate now directly verifies the hardened progression persistence/recovery contract, including rejection of structurally truncated primary saves in favor of a known-good backup.
- Clean Android release artifact verification run `34835983641` on the same source completed GREEN.
- The AAB run passed repository integrity, runtime gates, translation preparation, unsigned Release AAB export and artifact upload.
- Release AAB artifact: `rulebreak-android-release-aab`, 40,619,392 bytes, SHA-256 `3952a941cacf914e3bf5a36c2359c294cc8c9e647a31dc1d937e8060b1769549`.
- Debug APK artifact: `rulebreak-android-debug`, 23,877,362 bytes, SHA-256 `c2b7623da1aa29412bf467eecb27e54518de4e595adf1a382aa0a4b4d2406863`.
- Both artifacts are attached to the corresponding successful GitHub Actions runs.
- The AAB is unsigned by design; this does not constitute production signing or Google Play readiness.
- The temporary GDScript type-fix workflow has been removed after the permanent source fix was verified by the clean Android runs.
- Local execution environment still does not contain the Godot executable, so CI remains the authoritative runtime/build verification layer for this session.

## Release engineering
- `main.tscn` points directly to the canonical `scripts/game.gd` controller.
- `scripts/game.gd` directly instantiates `ChallengeViewV2`.
- Obsolete `game_bootstrap.gd` and duplicate `extended_localization.gd` were removed.
- Progression persists the current challenge level while remaining compatible with version-1 saves, validates the required save structure, recovers from a structurally invalid primary save using the backup, and enforces streak/current-level invariants.
- Answer feedback requests short Android haptic feedback.
- Answer handling rejects a second rapid answer at the logical input-state level, not only by disabling the visual buttons.
- Android Debug APK workflow is bounded with job/runtime/export timeouts.
- Unsigned Android Release AAB workflow is present and bounded with runtime/export timeouts.
- Verification workflows use concurrency cancellation to prevent stale runs from accumulating.
- Android release presets pin min SDK 24 / target SDK 36 and arm64 export.
- Production signing is intentionally not embedded in the repository.

## Next safe work
1. Keep automated semantic/runtime checks only where they materially improve confidence without expanding MVP scope.
2. Continue final UI/visual polish and feedback quality improvements.
3. Perform physical-device testing: touch, portrait layout, persistence/restart, haptics and all 100 levels.
4. Prepare production signing and complete the Google Play readiness audit.
5. Capture final store assets and run the signed AAB through an owner-side Play testing track.

## Current blockers
- Physical Android device testing is not available in this execution environment.
- Production signing/Play Console submission require owner-side release credentials and account access.
- Full audio/visual polish remains incomplete.

## Truth rule
Never claim a feature is implemented unless it exists in the repository and has been checked. If something is only designed or planned, label it PLANNED.

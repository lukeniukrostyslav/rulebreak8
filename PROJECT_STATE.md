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
Latest previously verified release-candidate source: `34e218e0f8e4f338e70937029b58529eed8c4578`.
Current hardening work has advanced `main` through additional parser, semantic QA, audio, Android preset and documentation changes; the current head is awaiting its full post-hardening Android verification cycle.
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
| Challenge Manager | 98% |
| Challenge Modules | 92% |
| 100-level content catalog | 90% |
| SEE | 92% |
| REMEMBER | 90% |
| REACT | 92% |
| SWITCH | 90% |
| TRICK | 85% |
| MIX | 82% |
| UI / UX | 82% |
| Android-first adaptation | 92% |
| Local Save / Progression | 96% |
| Localization | 95% |
| Fallback / language resilience | 98% |
| Audio / haptics / feedback | 40% |
| Static Integrity Tests | 99% |
| Runtime Tests | 98% |
| Automated QA | 98% |
| Android APK pipeline | 99% |
| Android AAB pipeline | 99% |
| Production signing | 0% |
| Physical Android QA | 0% |
| Google Play readiness | 8% |
| Release readiness | 25% |
| Documentation / Project State | 100% |
| Release-candidate hardening | 97% |

**Overall: approximately 75%** of the full commercial release target.

Percentages are management estimates against the complete product/release scope. They are not code-coverage measurements and must not be interpreted as physical-device verification.

## Local / GitHub hardening status — 2026-09-14
- Owner-provided ZIP was used as the original working source for the local hardening pass.
- Repository-only static integrity verification was re-run successfully.
- Obsolete duplicate `scripts/core/challenge_view.gd` was removed; V2 remains canonical.
- Progression persistence was hardened with durable previous-save backup rotation and strict typed payload validation.
- Malformed primary-save recovery is covered by regression tests.
- A Godot 4.3 parser issue in responsive grid spacing was found by an explicit compile gate and fixed with valid GDScript conditional syntax.
- A dedicated critical-GDScript compile workflow now verifies the controller, renderer, progression and audio scripts.
- All 100 catalog entries now have automated public-contract behavior coverage for accepted/rejected choices.
- All 100 catalog entries now have explicit English description fallback coverage when a rule translation key is unavailable.
- Audio feedback initialization and tone dispatch are covered by a Dummy-driver runtime smoke test.
- Android release preset duplicate configuration was cleaned up.
- Main Android verification and unsigned AAB verification now include the critical compile and new semantic runtime gates.
- README, QA-gate documentation and build-status documentation were synchronized with the current engineering truth.
- Current `main` head is `cd8cd6ac3eca8a5bad049f142d77c888402d8c43`; its post-hardening Android verification is pending/completing in GitHub Actions.

## Verification status — 2026-09-14
- Clean Android verification run `34835983629` on source `34e218e0f8e4f338e70937029b58529eed8c4578` completed GREEN.
- That run passed repository integrity, Godot 4.3 headless runtime tests, translation preparation, Android Debug APK export, APK upload and GitHub Release publication.
- The progression regression gate verifies durable backup recovery, malformed payload rejection and progression invariants.
- Clean Android release artifact verification run `34835983641` on the same source completed GREEN.
- The AAB run passed repository integrity, runtime gates, translation preparation, unsigned Release AAB export and artifact upload.
- Release AAB artifact from that verified source: `rulebreak-android-release-aab`, 40,619,392 bytes, SHA-256 `3952a941cacf914e3bf5a36c2359c294cc8c9e647a31dc1d937e8060b1769549`.
- Debug APK artifact from that verified source: `rulebreak-android-debug`, 23,877,362 bytes, SHA-256 `c2b7623da1aa29412bf467eecb27e54518de4e595adf1a382aa0a4b4d2406863`.
- The AAB is unsigned by design; this does not constitute production signing or Google Play readiness.
- New compile/catalog/localization/audio gates have already produced successful isolated runs on the corrected source chain; the latest combined Android/AAB cycle is treated as authoritative for the current head only after it completes.
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
1. Finish the post-hardening combined GitHub Android verification and inspect any failures against the current source SHA only.
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

# RULEBREAK — PROJECT STATE

## Purpose
RULEBREAK is an Android-first premium micro-puzzle game for Google Play.

Core promise: **The game that teaches you the rule — then makes you break it.**

## Current objective
Build a polished, offline-first MVP that can be tested on Android and prepared for Google Play.

Commercial target: one-time purchase around €1.99. MVP has no ads, subscriptions, IAP, backend, AI dependency, or required internet connection.

## Current phase
ENGINEERING / MVP BUILD

## Last verified repository state
Repository: `lukeniukrostyslav/rulebreak8`
Default branch: `main`
Current project foundation: Godot 4.3 configuration, 100-level challenge catalog, expanded runtime renderer, local progression, deterministic tests and Android export gates.

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
- Extended choices are family-aware and the runtime renderer is required by the manager test contract.
- Extended rule descriptions have an explicit English fallback so raw `RULE_*` keys are not intentionally shown.

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

## Current progress (management estimates)
Research 100%
Concept 100%
Game Design 100%
Visual Direction 78%
Architecture 85%
Monetization 90%
Viral Loop 90%
Engineering 50%
QA 15%
Google Play 0%
Release 0%
Overall approximately 58%

These percentages are estimates only and are not claims of runtime or release verification.

## Next safe work
1. Verify the current GitHub Actions runs for the final commit.
2. Run Godot runtime tests and Android export gates.
3. Device-test all 100 levels, touch targets, portrait layout and persistence.
4. Add production-quality audio/feedback and finish visual polish.
5. Prepare production signing and complete the Google Play readiness audit.

## Current blockers
- Physical Android device testing is not available in this execution environment.
- Production signing/Play Console submission require the owner-side release credentials and account access.

## Truth rule
Never claim a feature is implemented unless it exists in the repository and has been checked. If something is only designed or planned, label it PLANNED.

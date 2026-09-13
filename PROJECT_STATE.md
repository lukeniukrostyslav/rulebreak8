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
Current project foundation: Godot 4 configuration, main scene, initial game loop, README.

## Product rules
- Short challenges, generally 5–30 seconds.
- Player learns a rule, then detects a change, exception, or misleading interpretation.
- Failure must feel understandable rather than arbitrary.
- Minimal UI, large touch targets, fast feedback.
- Offline play is a core MVP requirement.
- Local progression only for MVP.

## Challenge families
SEE / REMEMBER / REACT / SWITCH / TRICK / MIX

## Initial challenge set
1. Find the only shape that changed.
2. Remember positions of 3 objects; one subtly changes.
3. Memorize a sequence of 3 symbols.
4. Repeat a sequence in reverse.
5. Tap the correct color before the timer ends.
6. Ignore the first signal; react to the second.
7. Rule changes from BLUE to RED after three actions.
8. Rule changes after a sound signal.
9. Word says BLUE while text is RED; choose by color.
10. Largest shape is not the correct answer.
11. Find an object moving at a different speed.
12. Choose the original order after objects disappear.
13. Tap only when X appears.
14. Cannot repeat the last action.
15. A DON’T PRESS instruction becomes the correct choice.
16. Find the mirrored object.
17. Rule disappears after two seconds.
18. Instruction changes during the round.
19. Obvious answer is deliberately wrong.
20. MIX: SEE + SWITCH + REACT.

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

## Current progress
Research 100%
Concept 100%
Game Design 100%
Visual Direction 70%
Architecture 85%
Monetization 90%
Viral Loop 90%
Engineering 10%
QA 0%
Google Play 0%
Release 0%
Overall approximately 72%

These percentages are management estimates only and must never be presented as verified implementation percentages.

## Next safe work
Continue engineering from the actual repository state. Inspect current files before changing architecture. Implement the reusable rule/challenge system, then complete the challenge families, UI, progression, local save, audio/feedback, tests and Android build configuration.

## Truth rule
Never claim a feature is implemented unless it exists in the repository and has been checked. If something is only designed or planned, label it PLANNED.

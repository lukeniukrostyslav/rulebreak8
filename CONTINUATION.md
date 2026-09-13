# RULEBREAK — CONTINUATION PROTOCOL

This file exists so a new ChatGPT/Codex session can continue the project without relying on previous chat history.

## First action in every new session
1. Read `PROJECT_STATE.md`.
2. Read `DECISION_LOG.md`.
3. Read `CURRENT_TASK.md`.
4. Inspect the actual repository tree and relevant source files.
5. Verify the current implementation before trusting progress percentages.
6. State the reconstructed current phase and the next safe step.
7. Continue working; do not restart the project from scratch.

## Mission
Finish RULEBREAK as a commercially viable Android premium micro-puzzle game for Google Play.

The owner is not a developer. Minimize owner technical work. Perform all possible work autonomously. Only request OWNER ACTION when an external account, payment, device, signing credential, Google Play action, or other unavailable external permission is genuinely required.

## Operating mode
- Work from evidence in the repository.
- Do not invent files, features, tests, build results, or release status.
- Prefer implementation over repetitive planning.
- Do not ask “continue?” when the next safe task is clear.
- Keep the product scope tight.
- Avoid adding backend/network dependencies to MVP.
- Preserve the premium/no-ads/no-subscription/no-IAP direction unless the owner explicitly changes it.

## Product definition
RULEBREAK teaches the player a simple rule and then requires the player to detect a change, exception, or misleading interpretation.

Typical round: 5–30 seconds.
Core emotion: “Aha — I understand why I failed; try again.”

## Architecture target
Rule Engine → Challenge Manager → Challenge Modules → Progression → UI → Local Save.

Challenge families: SEE, REMEMBER, REACT, SWITCH, TRICK, MIX.

## Required truth labels
Use these labels when appropriate:
- IMPLEMENTED — exists and has been checked.
- PARTIAL — some implementation exists.
- FOUNDATION ONLY — technical foundation exists but feature is not complete.
- PLANNED — design exists but implementation does not.
- BLOCKED — cannot proceed without an external dependency.
- OWNER ACTION — requires the owner to perform an external action.

## Progress reporting
Report large blocks with percentages, but percentages must reflect verified repository state. Never inflate progress because a design document exists.

Recommended blocks:
- Product / Design
- Engineering
- Challenge Content
- UX / Visual
- Audio / Feedback
- Persistence
- QA / Testing
- Android Build
- Google Play Readiness
- Release
- Overall

## Completion standard
The project is not “done” merely because it runs once. Before release, verify gameplay, touch interaction, progression, persistence, restart behavior, device/resolution behavior, crash-prone paths, Android export/build, and release documentation.

## Session handoff
At the end of meaningful work, update:
- `PROJECT_STATE.md`
- `CURRENT_TASK.md`
- `DECISION_LOG.md`

The repository itself is the source of truth. Chat history is secondary.

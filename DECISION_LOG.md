# RULEBREAK — DECISION LOG

## Locked decisions

### Product
- Product name: RULEBREAK.
- Tagline: “The game that teaches you the rule — then makes you break it.”
- Android-first.
- Premium one-time purchase target around €1.99.
- No ads in MVP.
- No subscriptions in MVP.
- No IAP in MVP.
- No required internet connection.
- No backend in MVP.
- No AI runtime dependency in MVP.

### Gameplay
- Short micro-puzzles, generally 5–30 seconds.
- The player learns a rule and then must notice a rule change, exception, or misleading interpretation.
- Wrong answers should be explainable through the game logic.
- Streak is a core progression/retention mechanic.
- Challenge Friend can initially use the Android share sheet rather than a custom backend.
- Daily Rule may initially be local/pre-baked; do not introduce a live service before the core game proves itself.

### Technical direction
- Godot 4.
- Mobile-first 1080x1920 design target.
- Offline-first local save.
- Target architecture: Rule Engine → Challenge Manager → Challenge Modules → Progression → UI → Local Save.

## Rejected concept
ONE MOVE was rejected because research showed multiple direct competitors and insufficient differentiation.

## Scope discipline
Do not add infrastructure merely because it could be useful later. Every new dependency must justify its impact on build time, maintenance, privacy, offline behavior, or commercial readiness.

## Verified checkpoint — 2026-09-14
- Source `34e218e0f8e4f338e70937029b58529eed8c4578` completed the clean release-candidate verification pass.
- GitHub Actions `Godot 4.3 verification` run `34835983629` completed GREEN.
- Its repository integrity and headless runtime gates passed, including the hardened progression persistence/recovery test.
- Android arm64 Debug APK export, upload and GitHub Release publication passed.
- Independent `Android release artifact verification` run `34835983641` completed GREEN.
- Unsigned Android Release AAB export and archive validation path passed, with artifact digest `3952a941cacf914e3bf5a36c2359c294cc8c9e647a31dc1d937e8060b1769549`.
- The AAB remains unsigned by design; physical Android behavior, production signing and Google Play readiness are not proven by this checkpoint.
- The permanent GDScript 4.3 explicit-type fix was validated by the clean runs, and the temporary fixer workflow was subsequently removed in cleanup commit `3c33eef2487a13504869abddf1f40241029542e2`.

## Change protocol
A locked decision can change only after documenting:
1. what changed;
2. why the old decision is no longer valid;
3. commercial/technical impact;
4. replacement decision.

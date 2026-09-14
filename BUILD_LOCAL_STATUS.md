# RULEBREAK — Build Status

## Local ZIP hardening checkpoint

This working copy was inspected and modified locally before repository publication.

### Proven in the local working copy
- Godot project structure is present and internally consistent.
- `tests/test_static_integrity.py` passes:
  - 100 unique challenge IDs
  - 20 seed + 80 extension entries
  - locked family distribution
  - 21 locale CSV headers and duplicate-key checks
  - Android API 36 target configuration
- The CI/Godot type-inference failures in `ChallengeViewV2` were hardened with explicit types for the affected locals.
- Progression now persists the current level and remains backward-compatible with older saves.
- Correct/wrong answer feedback now requests short Android haptic feedback.
- Android export presets and CI gates target API 36, matching the current Google Play submission requirement for new apps/updates.

### Not locally provable
- Godot 4.3 executable is not installed in this execution environment.
- A real Godot headless runtime test cannot be honestly marked PASS here.
- Android APK/AAB export cannot be honestly marked PASS here.
- Physical Android device QA is unavailable here.
- Production signing and Play Console submission require owner-side credentials/access.

### Required external verification
GitHub Actions should run the Godot runtime tests and Android exports after these changes are pushed. A successful workflow is the authoritative build evidence for this environment; device QA remains separate.

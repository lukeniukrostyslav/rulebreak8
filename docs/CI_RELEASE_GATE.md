# RULEBREAK — AUTHORITATIVE CI RELEASE GATE

The release source SHA is not considered verified until the required checks complete successfully on that same SHA.

## Required checks
1. Critical GDScript compile
2. Static integrity
3. Catalog behavior
4. Localization fallback
5. Audio feedback smoke
6. Main-scene boot
7. End-to-end gameplay smoke
8. Android Debug APK export
9. Unsigned Release AAB export

## Freshness rule
A successful run from an older SHA cannot certify a newer SHA. If source changes after a successful run, the release gate returns to PENDING until the same new SHA has authoritative evidence.

## Failure rule
A failed gate is release-blocking until its root cause is fixed and the affected workflow is rerun on the corrected SHA.

## Artifact rule
Successful export must identify the exact source SHA. Version labels alone are insufficient evidence.

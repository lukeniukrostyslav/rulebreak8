from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = {
    "docs/RELEASE_ARTIFACT_POLICY.md": ["Debug APK", "Unsigned Release AAB", "Signed Release AAB", "source SHA", "SHA-256", ".metadata.txt"],
    "docs/CI_RELEASE_GATE.md": ["Critical GDScript compile", "End-to-end gameplay smoke", "Unsigned Release AAB export", "Freshness rule"],
    "docs/RELEASE_READINESS_CHECKLIST.md": ["Physical Android QA", "Production release", "fresh authoritative GREEN"],
    "docs/PHYSICAL_ANDROID_QA.md": ["portrait", "persistence", "haptic", "all 100"],
    "docs/PHYSICAL_ANDROID_QA_CHECKLIST.md": ["Install and launch", "Touch and layout", "all 100 catalog entries", "airplane mode"],
    "docs/PHYSICAL_ANDROID_QA_RECORD.md": ["APK SHA-256", "Source commit SHA", "Final sign-off", "Build identity"],
    "docs/RELEASE_SIGNING.md": ["keystore", "Never commit", "signed Release AAB", "Google Play"],
    "docs/QA_EVIDENCE_MATRIX.md": ["CI evidence", "Physical device", "Signed artifact"],
    "docs/RELEASE_GO_NO_GO.md": ["GO requires", "NO-GO triggers", "signed AAB"],
}

for relative, markers in REQUIRED.items():
    path = ROOT / relative
    assert path.is_file(), f"Missing release document: {relative}"
    text = path.read_text(encoding="utf-8")
    for marker in markers:
        assert marker.lower() in text.lower(), f"Missing marker {marker!r} in {relative}"

# Release evidence must not accidentally certify external gates.
evidence = (ROOT / "docs/RELEASE_EVIDENCE_2026-09-14.md").read_text(encoding="utf-8").lower()
assert "physical android qa: not verified" in evidence
assert "production signing: not verified" in evidence
assert "signed release aab: not verified" in evidence
assert "google play testing/production: not verified" in evidence

print("RULEBREAK release documentation: PASS — required release boundaries, artifact metadata, physical QA record, and evidence rules are present")

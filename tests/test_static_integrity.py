#!/usr/bin/env python3
"""Repository-only integrity gate for RULEBREAK.

This intentionally uses only the Python standard library so CI can catch
catalog/localization/export configuration regressions before Godot boots.
It is not a replacement for the Godot runtime tests.
"""
from __future__ import annotations

import csv
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANAGER = ROOT / "scripts/core/challenge_manager.gd"
CATALOG = ROOT / "scripts/data/challenges.json"
PRESETS = ROOT / "export_presets.cfg"
LOCALE_DIR = ROOT / "locale"

EXPECTED_LOCALES = [
    "en", "es", "pt_BR", "fr", "de", "it", "ru", "uk", "pl", "tr", "nl",
    "ar", "he", "hi", "id", "vi", "th", "ja", "ko", "zh", "zh_TW",
]
EXPECTED_FAMILIES = {"SEE", "REMEMBER", "REACT", "SWITCH", "TRICK", "MIX"}


def fail(message: str) -> None:
    raise AssertionError(message)


def main() -> None:
    manager = MANAGER.read_text(encoding="utf-8")
    metadata = json.loads(CATALOG.read_text(encoding="utf-8"))

    if metadata["total_levels"] != 100:
        fail("catalog metadata total_levels must be 100")
    if metadata["base_seed_levels"] != 20:
        fail("catalog metadata base_seed_levels must be 20")
    if metadata["generated_extension_levels"] != 80:
        fail("catalog metadata generated_extension_levels must be 80")

    seed_ids = [item["id"] for item in metadata["mvp_seed"]]
    if len(seed_ids) != 20 or len(seed_ids) != len(set(seed_ids)):
        fail("mvp_seed must contain 20 unique IDs")

    base_ids = re.findall(r'\{"id":"([^"]+)"', manager)
    if len(base_ids) != 20:
        fail(f"ChallengeManager base catalog entries: expected 20, got {len(base_ids)}")
    if base_ids != seed_ids:
        fail("ChallengeManager seed IDs differ from scripts/data/challenges.json")

    extension_rows = re.findall(
        r'\["(SEE|REMEMBER|REACT|SWITCH|TRICK|MIX)",\s*"([^"]+)",\s*"([^"]+)",\s*(\d+)\]',
        manager,
    )
    if len(extension_rows) != 80:
        fail(f"ChallengeManager extension entries: expected 80, got {len(extension_rows)}")

    for family, challenge_id, description, correct in extension_rows:
        if not challenge_id:
            fail(f"{family}: extension challenge has empty ID")
        if not description.strip():
            fail(f"{challenge_id}: extension challenge has empty English description")
        correct_index = int(correct)
        if not 0 <= correct_index < 4:
            fail(f"{challenge_id}: correct choice index must be in [0, 3], got {correct_index}")

    ids = base_ids + [row[1] for row in extension_rows]
    if len(ids) != 100 or len(ids) != len(set(ids)):
        fail("ChallengeManager must contain exactly 100 unique challenge IDs")

    families = [row[0] for row in extension_rows]
    family_counts = Counter(families)
    seed_family_counts = Counter(item["family"] for item in metadata["mvp_seed"])
    final_counts = seed_family_counts + family_counts
    expected_counts = {
        "SEE": 18, "REMEMBER": 20, "REACT": 18,
        "SWITCH": 19, "TRICK": 19, "MIX": 6,
    }
    if final_counts != expected_counts:
        fail(f"family distribution mismatch: {dict(final_counts)}")
    if set(final_counts) != EXPECTED_FAMILIES:
        fail("all six challenge families must be represented")

    for path in sorted(LOCALE_DIR.glob("*.csv")):
        with path.open(encoding="utf-8", newline="") as fh:
            rows = list(csv.reader(fh))
        if not rows or rows[0][0] != "keys":
            fail(f"{path.name}: missing keys header")
        if rows[0][1:] != EXPECTED_LOCALES:
            fail(f"{path.name}: locale header mismatch")
        width = len(rows[0])
        keys = []
        for row in rows[1:]:
            if len(row) != width:
                fail(f"{path.name}: inconsistent CSV width")
            key = row[0].strip()
            if key:
                keys.append(key)
        if len(keys) != len(set(keys)):
            fail(f"{path.name}: duplicate translation key")

    presets = PRESETS.read_text(encoding="utf-8")
    if 'gradle_build/target_sdk="36"' not in presets:
        fail("Android presets must target API 36 for current Google Play submission requirements")
    if 'package/unique_name="com.rulebreak.game"' not in presets:
        fail("Android package name missing")
    if 'architectures/arm64-v8a=true' not in presets:
        fail("Android presets must include arm64-v8a")
    if 'architectures/armeabi-v7a=false' not in presets or 'architectures/x86=false' not in presets or 'architectures/x86_64=false' not in presets:
        fail("Android presets must keep the locked arm64-only MVP ABI surface")

    print("RULEBREAK static integrity: PASS — 100 unique levels, descriptions/correct-index contract, family distribution, 21 locales, Android API 36/arm64")


if __name__ == "__main__":
    main()
